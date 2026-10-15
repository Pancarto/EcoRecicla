# ============================================================
# ECORECICLA - SERVICIO DE EMPRESAS ALIADAS
# ============================================================

from database.conexion import obtener_conexion


# ============================================================
# LISTAR EMPRESAS
# ============================================================

def obtener_empresas():

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute("""
            SELECT
                id_empresa,
                nombre,
                nit,
                descripcion,
                telefono,
                correo,
                direccion,
                estado
            FROM empresas_aliadas
            ORDER BY nombre ASC
        """)

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()


# ============================================================
# OBTENER EMPRESA
# ============================================================

def obtener_empresa(id_empresa):

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute("""
            SELECT
                id_empresa,
                nombre,
                nit,
                descripcion,
                telefono,
                correo,
                direccion,
                estado
            FROM empresas_aliadas
            WHERE id_empresa = %s
        """, (id_empresa,))

        return cursor.fetchone()

    finally:

        cursor.close()
        conexion.close()