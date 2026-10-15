# ============================================================
# ECORECICLA - SERVICIO DE AUTENTICACIÓN
# ============================================================

from werkzeug.security import generate_password_hash, check_password_hash

from database.conexion import obtener_conexion


def registrar_usuario(
    id_tipo_documento,
    numero_documento,
    nombres,
    apellidos,
    correo,
    telefono,
    password
):
    """
    Registra un nuevo usuario y crea automáticamente
    su saldo inicial de puntos.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor()

    try:
        # ----------------------------------------------------
        # Verificar si el documento ya existe
        # ----------------------------------------------------

        cursor.execute(
            """
            SELECT id_usuario
            FROM usuarios
            WHERE numero_documento = %s
            """,
            (numero_documento,)
        )

        if cursor.fetchone():
            return False, "El número de documento ya está registrado."

        # ----------------------------------------------------
        # Verificar si el correo ya existe
        # ----------------------------------------------------

        cursor.execute(
            """
            SELECT id_usuario
            FROM usuarios
            WHERE correo = %s
            """,
            (correo,)
        )

        if cursor.fetchone():
            return False, "El correo electrónico ya está registrado."

        # ----------------------------------------------------
        # Encriptar contraseña
        # ----------------------------------------------------

        password_hash = generate_password_hash(password)

        # ----------------------------------------------------
        # Crear usuario
        # Rol 1 = USUARIO
        # ----------------------------------------------------

        cursor.execute(
            """
            INSERT INTO usuarios (
                id_rol,
                id_tipo_documento,
                numero_documento,
                nombres,
                apellidos,
                correo,
                telefono,
                password_hash
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """,
            (
                1,
                id_tipo_documento,
                numero_documento,
                nombres,
                apellidos,
                correo,
                telefono,
                password_hash
            )
        )

        id_usuario = cursor.lastrowid

        # ----------------------------------------------------
        # Crear saldo inicial
        # ----------------------------------------------------

        cursor.execute(
            """
            INSERT INTO saldos_puntos (
                id_usuario,
                puntos_disponibles,
                puntos_acumulados
            )
            VALUES (%s, 0, 0)
            """,
            (id_usuario,)
        )

        conexion.commit()

        return True, "Usuario registrado correctamente."

    except Exception as error:

        conexion.rollback()

        return False, f"Error al registrar usuario: {error}"

    finally:

        cursor.close()
        conexion.close()


def autenticar_usuario(correo, password):
    """
    Verifica las credenciales del usuario.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                id_usuario,
                id_rol,
                nombres,
                apellidos,
                correo,
                password_hash,
                estado
            FROM usuarios
            WHERE correo = %s
            """,
            (correo,)
        )

        usuario = cursor.fetchone()

        if not usuario:
            return None

        if usuario["estado"] != 1:
            return None

        if not check_password_hash(
            usuario["password_hash"],
            password
        ):
            return None

        # Actualizar último acceso

        cursor.execute(
            """
            UPDATE usuarios
            SET ultimo_acceso = NOW()
            WHERE id_usuario = %s
            """,
            (usuario["id_usuario"],)
        )

        conexion.commit()

        return usuario

    finally:

        cursor.close()
        conexion.close()


def obtener_tipos_documento():
    """
    Obtiene los tipos de documento activos.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                id_tipo_documento,
                nombre,
                abreviatura
            FROM tipos_documento
            WHERE estado = 1
            ORDER BY nombre
            """
        )

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()