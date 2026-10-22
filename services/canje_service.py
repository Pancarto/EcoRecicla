# ============================================================
# ECORECICLA - SERVICIO DE CANJES
# ============================================================

from database.conexion import obtener_conexion

import secrets
import string


# ============================================================
# GENERAR CÓDIGO DE TICKET
# ============================================================

def generar_codigo_ticket():

    caracteres = string.ascii_uppercase + string.digits

    codigo = "".join(
        secrets.choice(caracteres)
        for _ in range(8)
    )

    return f"ECO-{codigo}"


# ============================================================
# OBTENER TIPO DE MOVIMIENTO PARA CANJE
# ============================================================

def obtener_tipo_movimiento_canje(cursor):

    cursor.execute(
        """
        SELECT
            id_tipo_movimiento
        FROM tipos_movimiento_puntos
        WHERE nombre = 'RECOMPENSA'
          AND naturaleza = 'EGRESO'
          AND estado = 1
        LIMIT 1
        """
    )

    resultado = cursor.fetchone()

    if not resultado:
        return None

    return resultado["id_tipo_movimiento"]

# ============================================================
# OBTENER CANJES DEL USUARIO
# ============================================================

def obtener_canjes_usuario(id_usuario):

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                c.id_canje,
                c.fecha_canje,
                c.puntos_utilizados,
                c.estado,
                c.codigo_ticket,

                r.nombre AS recompensa,

                ea.nombre AS empresa

            FROM canjes c

            INNER JOIN recompensas r
                ON c.id_recompensa = r.id_recompensa

            LEFT JOIN empresas_aliadas ea
                ON r.id_empresa = ea.id_empresa

            WHERE c.id_usuario = %s

            ORDER BY c.fecha_canje DESC
            """,
            (id_usuario,)
        )

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()


# ============================================================
# REALIZAR CANJE
# ============================================================

def realizar_canje(id_usuario, id_recompensa):

    conexion = obtener_conexion()

    cursor = conexion.cursor(dictionary=True)

    try:

        # ====================================================
        # INICIAR TRANSACCIÓN
        # ====================================================

        conexion.start_transaction()

        # ====================================================
        # 1. OBTENER RECOMPENSA
        # ====================================================

        cursor.execute(
            """
            SELECT
                id_recompensa,
                nombre,
                puntos_requeridos,
                stock,
                estado
            FROM recompensas
            WHERE id_recompensa = %s
            FOR UPDATE
            """,
            (id_recompensa,)
        )

        recompensa = cursor.fetchone()

        if not recompensa:

            conexion.rollback()

            return False, "La recompensa no existe."


        # ====================================================
        # 2. VALIDAR ESTADO
        # ====================================================

        if recompensa["estado"] != "ACTIVA":

            conexion.rollback()

            return False, "La recompensa no está disponible."


        # ====================================================
        # 3. VALIDAR STOCK
        # ====================================================

        if recompensa["stock"] <= 0:

            conexion.rollback()

            return False, "La recompensa está agotada."


        # ====================================================
        # 4. OBTENER SALDO DEL USUARIO
        # ====================================================

        cursor.execute(
            """
            SELECT
                puntos_disponibles
            FROM saldos_puntos
            WHERE id_usuario = %s
            FOR UPDATE
            """,
            (id_usuario,)
        )

        saldo = cursor.fetchone()

        if not saldo:

            conexion.rollback()

            return False, (
                "El usuario no tiene una cuenta de puntos."
            )


        # ====================================================
        # 5. VALIDAR PUNTOS
        # ====================================================

        puntos_necesarios = recompensa["puntos_requeridos"]

        puntos_disponibles = saldo["puntos_disponibles"]

        if puntos_disponibles < puntos_necesarios:

            faltantes = (
                puntos_necesarios
                - puntos_disponibles
            )

            conexion.rollback()

            return False, (
                f"No tienes suficientes puntos. "
                f"Te faltan {faltantes} puntos."
            )


        # ====================================================
        # 6. OBTENER TIPO DE MOVIMIENTO "CANJE"
        # ====================================================

        id_tipo_movimiento = obtener_tipo_movimiento_canje(
            cursor
        )

        if not id_tipo_movimiento:

            conexion.rollback()

            return False, (
                "No existe el tipo de movimiento "
                "'CANJE' en la base de datos."
            )


        # ====================================================
        # 7. GENERAR TICKET
        # ====================================================

        codigo_ticket = generar_codigo_ticket()


        # ====================================================
        # 8. DESCONTAR PUNTOS
        # ====================================================

        cursor.execute(
            """
            UPDATE saldos_puntos

            SET puntos_disponibles =
                puntos_disponibles - %s

            WHERE id_usuario = %s
            """,
            (
                puntos_necesarios,
                id_usuario
            )
        )


        # ====================================================
        # 9. DESCONTAR STOCK
        # ====================================================

        cursor.execute(
            """
            UPDATE recompensas

            SET stock = stock - 1

            WHERE id_recompensa = %s
              AND stock > 0
            """,
            (id_recompensa,)
        )


        if cursor.rowcount != 1:

            conexion.rollback()

            return False, (
                "No fue posible actualizar el stock."
            )


        # ====================================================
        # 10. CREAR CANJE (CON ID MANUAL SEGURO)
        # ====================================================

        cursor.execute(
            """
            SELECT COALESCE(MAX(id_canje), 0) + 1 AS next_id FROM canjes
            """
        )
        res_id = cursor.fetchone()
        id_canje = res_id["next_id"] if res_id and "next_id" in res_id else 1

        cursor.execute(
            """
            INSERT INTO canjes (
                id_canje,
                id_usuario,
                id_recompensa,
                puntos_utilizados,
                codigo_ticket,
                estado
            )
            VALUES (%s, %s, %s, %s, %s, 'GENERADO')
            """,
            (
                id_canje,
                id_usuario,
                id_recompensa,
                puntos_necesarios,
                codigo_ticket
            )
        )


        # ====================================================
        # 11. REGISTRAR MOVIMIENTO DE PUNTOS (CON ID MANUAL SEGURO)
        # ====================================================

        cursor.execute(
            """
            SELECT COALESCE(MAX(id_movimiento), 0) + 1 AS next_mov FROM movimientos_puntos
            """
        )
        res_mov = cursor.fetchone()
        id_movimiento = res_mov["next_mov"] if res_mov and "next_mov" in res_mov else 1

        cursor.execute(
            """
            INSERT INTO movimientos_puntos (
                id_movimiento,
                id_usuario,
                id_tipo_movimiento,
                puntos,
                descripcion,
                id_canje
            )
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                id_movimiento,
                id_usuario,
                id_tipo_movimiento,
                puntos_necesarios * -1,
                f"Canje de recompensa: {recompensa['nombre']}",
                id_canje
            )
        )


        # ====================================================
        # 12. CONFIRMAR TODO
        # ====================================================

        conexion.commit()


        # ====================================================
        # 13. DEVOLVER RESULTADO
        # ====================================================

        return True, {

            "id_canje": id_canje,

            "codigo_ticket": codigo_ticket,

            "recompensa": recompensa["nombre"],

            "puntos_utilizados": puntos_necesarios

        }


    except Exception as error:

        conexion.rollback()

        return False, (
            f"Error al realizar el canje: {error}"
        )


    finally:

        cursor.close()

        conexion.close()
