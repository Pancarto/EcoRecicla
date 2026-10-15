# ============================================================
# ECORECICLA - ADMINISTRACIÓN DE RECOMPENSAS
# ============================================================

from database.conexion import obtener_conexion


# ============================================================
# LISTAR RECOMPENSAS
# ============================================================

def obtener_todas_recompensas():

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute("""
            SELECT
                r.id_recompensa,
                r.nombre,
                r.descripcion,
                r.puntos_requeridos,
                r.stock,
                r.estado,

                cr.nombre AS categoria,

                ea.nombre AS empresa

            FROM recompensas r

            INNER JOIN categorias_recompensa cr
                ON r.id_categoria_recompensa =
                   cr.id_categoria_recompensa

            LEFT JOIN empresas_aliadas ea
                ON r.id_empresa = ea.id_empresa

            ORDER BY r.id_recompensa DESC
        """)

        return cursor.fetchall()

    finally:

        cursor.close()
        conexion.close()


# ============================================================
# CAMBIAR STOCK
# ============================================================

def actualizar_stock(id_recompensa, nuevo_stock):

    conexion = obtener_conexion()
    cursor = conexion.cursor()

    try:

        cursor.execute("""
            UPDATE recompensas
            SET
                stock = %s,
                estado =
                    CASE
                        WHEN %s <= 0
                        THEN 'AGOTADA'
                        ELSE 'ACTIVA'
                    END
            WHERE id_recompensa = %s
        """, (
            nuevo_stock,
            nuevo_stock,
            id_recompensa
        ))

        conexion.commit()

        return True

    except Exception:

        conexion.rollback()

        return False

    finally:

        cursor.close()
        conexion.close()