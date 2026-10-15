# ============================================================
# ECORECICLA - SERVICIO DE RECOMPENSAS
# ============================================================

from database.conexion import obtener_conexion


def obtener_recompensas_disponibles():
    """
    Obtiene las recompensas actualmente disponibles.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                r.id_recompensa,
                r.nombre,
                r.descripcion,
                r.puntos_requeridos,
                r.stock,
                r.imagen,

                cr.nombre AS categoria,

                ea.nombre AS empresa

            FROM recompensas r

            INNER JOIN categorias_recompensa cr
                ON r.id_categoria_recompensa =
                   cr.id_categoria_recompensa

            LEFT JOIN empresas_aliadas ea
                ON r.id_empresa = ea.id_empresa

            WHERE r.estado = 'ACTIVA'
              AND r.stock > 0

              AND (
                  r.fecha_fin IS NULL
                  OR r.fecha_fin >= NOW()
              )

            ORDER BY r.puntos_requeridos ASC
            """
        )

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()


def obtener_recompensa(id_recompensa):
    """
    Obtiene una recompensa específica.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                r.id_recompensa,
                r.nombre,
                r.descripcion,
                r.puntos_requeridos,
                r.stock,
                r.imagen,

                cr.nombre AS categoria,

                ea.nombre AS empresa

            FROM recompensas r

            INNER JOIN categorias_recompensa cr
                ON r.id_categoria_recompensa =
                   cr.id_categoria_recompensa

            LEFT JOIN empresas_aliadas ea
                ON r.id_empresa = ea.id_empresa

            WHERE r.id_recompensa = %s
            """,
            (id_recompensa,)
        )

        return cursor.fetchone()

    finally:

        cursor.close()
        conexion.close()