# ============================================================
# ECORECICLA - ADMINISTRACIÓN DE USUARIOS
# ============================================================

from database.conexion import obtener_conexion


# ============================================================
# LISTAR USUARIOS
# ============================================================

def obtener_usuarios():

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute("""
            SELECT
                u.id_usuario,
                u.nombre,
                u.apellido,
                u.email,
                u.telefono,
                u.fecha_registro,
                u.estado,

                r.nombre AS rol

            FROM usuarios u

            INNER JOIN roles r
                ON u.id_rol = r.id_rol

            ORDER BY u.fecha_registro DESC
        """)

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()
