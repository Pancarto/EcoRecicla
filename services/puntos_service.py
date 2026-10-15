# ============================================================
# ECORECICLA - SERVICIO DE PUNTOS
# ============================================================

from database.conexion import obtener_conexion


def obtener_saldo_usuario(id_usuario):
    """
    Obtiene el saldo actual de puntos del usuario.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                puntos_disponibles,
                puntos_acumulados
            FROM saldos_puntos
            WHERE id_usuario = %s
            """,
            (id_usuario,)
        )

        return cursor.fetchone()

    finally:

        cursor.close()
        conexion.close()


def obtener_movimientos_usuario(id_usuario):
    """
    Obtiene el historial de movimientos de puntos.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                mp.id_movimiento,
                mp.puntos,
                mp.descripcion,
                mp.fecha_movimiento,
                tmp.nombre AS tipo_movimiento,
                tmp.naturaleza
            FROM movimientos_puntos mp

            INNER JOIN tipos_movimiento_puntos tmp
                ON mp.id_tipo_movimiento =
                   tmp.id_tipo_movimiento

            WHERE mp.id_usuario = %s

            ORDER BY mp.fecha_movimiento DESC
            """,
            (id_usuario,)
        )

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()


def obtener_estadisticas_usuario(id_usuario):
    """
    Obtiene estadísticas generales del usuario.
    """

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                COUNT(*) AS total_reciclajes,
                COALESCE(SUM(peso_total), 0) AS peso_total,
                COALESCE(SUM(puntos_obtenidos), 0) AS puntos_generados
            FROM reciclajes
            WHERE id_usuario = %s
              AND estado != 'ANULADO'
            """,
            (id_usuario,)
        )

        estadisticas = cursor.fetchone()

        cursor.execute(
            """
            SELECT COUNT(*) AS total_canjes
            FROM canjes
            WHERE id_usuario = %s
              AND estado != 'CANCELADO'
            """,
            (id_usuario,)
        )

        canjes = cursor.fetchone()

        estadisticas["total_canjes"] = canjes["total_canjes"]

        return estadisticas

    finally:

        cursor.close()
        conexion.close()