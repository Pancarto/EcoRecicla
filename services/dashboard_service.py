# ============================================================
# ECORECICLA - ESTADÍSTICAS DEL PANEL ADMINISTRATIVO
# ============================================================

from database.conexion import obtener_conexion


# ============================================================
# ESTADÍSTICAS GENERALES
# ============================================================

def obtener_estadisticas_generales():

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        estadisticas = {}

        # ----------------------------------------------------
        # USUARIOS
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COUNT(*) AS total
            FROM usuarios
            WHERE estado = 1
        """)

        estadisticas["usuarios"] = cursor.fetchone()["total"]


        # ----------------------------------------------------
        # RECICLAJES
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COUNT(*) AS total
            FROM reciclajes
        """)

        estadisticas["reciclajes"] = cursor.fetchone()["total"]


        # ----------------------------------------------------
        # CANJES
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COUNT(*) AS total
            FROM canjes
        """)

        estadisticas["canjes"] = cursor.fetchone()["total"]


        # ----------------------------------------------------
        # PUNTOS GENERADOS
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COALESCE(
                SUM(puntos),
                0
            ) AS total

            FROM movimientos_puntos

            WHERE id_tipo_movimiento = 1
        """)

        estadisticas["puntos_generados"] = (
            cursor.fetchone()["total"]
        )


        # ----------------------------------------------------
        # RECOMPENSAS ACTIVAS
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COUNT(*) AS total

            FROM recompensas

            WHERE estado = 'ACTIVA'
              AND stock > 0
        """)

        estadisticas["recompensas"] = (
            cursor.fetchone()["total"]
        )


        # ----------------------------------------------------
        # EMPRESAS ALIADAS
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COUNT(*) AS total

            FROM empresas_aliadas

            WHERE estado = 1
        """)

        estadisticas["empresas"] = (
            cursor.fetchone()["total"]
        )


        # ----------------------------------------------------
        # CANJES PENDIENTES
        # ----------------------------------------------------

        cursor.execute("""
            SELECT COUNT(*) AS total

            FROM canjes

            WHERE estado = 'GENERADO'
        """)

        estadisticas["canjes_pendientes"] = (
            cursor.fetchone()["total"]
        )


        return estadisticas

    finally:

        cursor.close()
        conexion.close()