# ============================================================
# ECORECICLA - SERVICIO DE RECICLAJE
# ============================================================

from database.conexion import obtener_conexion
import uuid


def generar_codigo_reciclaje():
    """
    Genera un identificador único para cada reciclaje.
    """

    return "REC-" + uuid.uuid4().hex[:10].upper()


def registrar_reciclaje(
    id_usuario,
    id_maquina,
    id_tipo_material,
    peso
):
    """
    Registra un reciclaje completo.

    El proceso:
        1. Consulta el material.
        2. Calcula puntos.
        3. Crea el reciclaje.
        4. Crea el detalle.
        5. Actualiza el saldo.
        6. Registra el movimiento.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        # ====================================================
        # VALIDAR PESO
        # ====================================================

        if peso <= 0:

            return False, "El peso debe ser mayor que cero."

        # ====================================================
        # CONSULTAR MATERIAL
        # ====================================================

        cursor.execute(
            """
            SELECT
                id_tipo_material,
                nombre,
                puntos_por_unidad
            FROM tipos_material
            WHERE id_tipo_material = %s
              AND estado = 1
            """,
            (id_tipo_material,)
        )

        material = cursor.fetchone()

        if not material:

            return False, "El material seleccionado no existe."

        # ====================================================
        # VERIFICAR QUE LA MÁQUINA ACEPTE EL MATERIAL
        # ====================================================

        cursor.execute(
            """
            SELECT 1
            FROM maquina_material
            WHERE id_maquina = %s
              AND id_tipo_material = %s
              AND activo = 1
            """,
            (
                id_maquina,
                id_tipo_material
            )
        )

        if not cursor.fetchone():

            return False, (
                "La máquina no acepta este tipo de material."
            )

        # ====================================================
        # CALCULAR PUNTOS
        # ====================================================

        puntos = peso * float(
            material["puntos_por_unidad"]
        )

        codigo = generar_codigo_reciclaje()

        # ====================================================
        # OBTENER MANUALMENTE id_reciclaje (para TiDB Cloud)
        # ====================================================
        cursor.execute("SELECT COALESCE(MAX(id_reciclaje), 0) + 1 FROM reciclajes")
        id_reciclaje = cursor.fetchone()
        # Manejo por si el cursor es dictionary=True o tupla normal
        if isinstance(id_reciclaje, dict):
            id_reciclaje = list(id_reciclaje.values())[0]
        else:
            id_reciclaje = id_reciclaje[0]

        # ====================================================
        # CREAR RECICLAJE
        # ====================================================

        cursor.execute(
            """
            INSERT INTO reciclajes (
                id_reciclaje,
                id_usuario,
                id_maquina,
                peso_total,
                puntos_obtenidos,
                codigo_reciclaje,
                estado
            )
            VALUES (
                %s,
                %s,
                %s,
                %s,
                %s,
                %s,
                'REGISTRADO'
            )
            """,
            (
                id_reciclaje,
                id_usuario,
                id_maquina,
                peso,
                puntos,
                codigo
            )
        )

        # ====================================================
        # CREAR DETALLE (Si tiene id_detalle autoincrementable o similar, validemos)
        # ====================================================

        cursor.execute(
            """
            INSERT INTO detalle_reciclaje (
                id_reciclaje,
                id_tipo_material,
                cantidad,
                puntos
            )
            VALUES (
                %s,
                %s,
                %s,
                %s
            )
            """,
            (
                id_reciclaje,
                id_tipo_material,
                peso,
                puntos
            )
        )

        # ====================================================
        # ACTUALIZAR SALDO
        # ====================================================

        cursor.execute(
            """
            UPDATE saldos_puntos
            SET
                puntos_disponibles =
                    puntos_disponibles + %s,

                puntos_acumulados =
                    puntos_acumulados + %s

            WHERE id_usuario = %s
            """,
            (
                puntos,
                puntos,
                id_usuario
            )
        )

        # ====================================================
        # OBTENER MANUALMENTE id_movimiento (para TiDB Cloud)
        # ====================================================
        cursor.execute("SELECT COALESCE(MAX(id_movimiento), 0) + 1 FROM movimientos_puntos")
        id_movimiento = cursor.fetchone()
        if isinstance(id_movimiento, dict):
            id_movimiento = list(id_movimiento.values())[0]
        else:
            id_movimiento = id_movimiento[0]

        # ====================================================
        # REGISTRAR MOVIMIENTO
        # ====================================================

        cursor.execute(
            """
            INSERT INTO movimientos_puntos (
                id_movimiento,
                id_usuario,
                id_tipo_movimiento,
                puntos,
                descripcion,
                id_reciclaje
            )
            VALUES (
                %s,
                %s,
                1,
                %s,
                %s,
                %s
            )
            """,
            (
                id_movimiento,
                id_usuario,
                puntos,
                f"Reciclaje de {material['nombre']}",
                id_reciclaje
            )
        )

        conexion.commit()

        return True, {
            "id_reciclaje": id_reciclaje,
            "codigo": codigo,
            "peso": peso,
            "puntos": puntos,
            "material": material["nombre"]
        }

    except Exception as error:

        conexion.rollback()

        return False, f"Error al registrar reciclaje: {error}"

    finally:

        cursor.close()
        conexion.close()


def obtener_materiales():
    """
    Obtiene los materiales disponibles.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                id_tipo_material,
                nombre,
                descripcion,
                unidad_medida,
                puntos_por_unidad
            FROM tipos_material
            WHERE estado = 1
            ORDER BY nombre
            """
        )

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()


def obtener_reciclajes_usuario(id_usuario):
    """
    Obtiene el historial de reciclajes del usuario.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                r.id_reciclaje,
                r.codigo_reciclaje,
                r.fecha_reciclaje,
                r.peso_total,
                r.puntos_obtenidos,
                r.estado,

                m.nombre AS maquina

            FROM reciclajes r

            INNER JOIN maquinas m
                ON r.id_maquina = m.id_maquina

            WHERE r.id_usuario = %s

            ORDER BY r.fecha_reciclaje DESC
            """,
            (id_usuario,)
        )

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()
