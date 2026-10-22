# ============================================================
# ECORECICLA - SERVICIO DE VALIDACIÓN DE TICKETS
# ============================================================

from database.conexion import obtener_conexion


# ============================================================
# BUSCAR TICKET
# ============================================================

def buscar_ticket(codigo_ticket):

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                c.id_canje,
                c.codigo_ticket,
                c.id_usuario,
                c.id_recompensa,
                c.puntos_utilizados,
                c.fecha_canje,
                c.estado,

                r.nombre AS recompensa,
                r.descripcion AS descripcion_recompensa,

                CONCAT(
                    u.nombre,
                    ' ',
                    u.apellido
                ) AS usuario_nombre,

                ea.nombre AS empresa

            FROM canjes c

            INNER JOIN recompensas r
                ON c.id_recompensa = r.id_recompensa

            INNER JOIN usuarios u
                ON c.id_usuario = u.id_usuario

            LEFT JOIN empresas_aliadas ea
                ON r.id_empresa = ea.id_empresa

            WHERE c.codigo_ticket = %s

            LIMIT 1
            """,
            (codigo_ticket,)
        )

        return cursor.fetchone()

    finally:

        cursor.close()
        conexion.close()


# ============================================================
# VALIDAR TICKET
# ============================================================

def validar_ticket(codigo_ticket):

    ticket = buscar_ticket(codigo_ticket)

    if not ticket:

        return False, "El código ingresado no existe."

    if ticket["estado"] == "ENTREGADO":

        return False, "Este ticket ya fue utilizado."

    if ticket["estado"] == "CANCELADO":

        return False, "Este ticket fue cancelado."

    if ticket["estado"] == "VENCIDO":

        return False, "Este ticket está vencido."

    if ticket["estado"] != "GENERADO":

        return False, (
            f"El ticket no puede ser utilizado. "
            f"Estado actual: {ticket['estado']}"
        )

    return True, ticket


# ============================================================
# ENTREGAR RECOMPENSA
# ============================================================

def entregar_recompensa(codigo_ticket):

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        conexion.start_transaction()

        cursor.execute(
            """
            SELECT
                id_canje,
                codigo_ticket,
                estado

            FROM canjes

            WHERE codigo_ticket = %s

            FOR UPDATE
            """,
            (codigo_ticket,)
        )

        ticket = cursor.fetchone()

        if not ticket:

            conexion.rollback()

            return False, "El ticket no existe."

        if ticket["estado"] == "ENTREGADO":

            conexion.rollback()

            return False, (
                "Este ticket ya fue utilizado."
            )

        if ticket["estado"] != "GENERADO":

            conexion.rollback()

            return False, (
                f"No se puede entregar. "
                f"Estado: {ticket['estado']}"
            )

        cursor.execute(
            """
            UPDATE canjes

            SET estado = 'ENTREGADO'

            WHERE id_canje = %s
              AND estado = 'GENERADO'
            """,
            (ticket["id_canje"],)
        )

        if cursor.rowcount != 1:

            conexion.rollback()

            return False, (
                "No fue posible completar la entrega."
            )

        conexion.commit()

        return True, (
            "Recompensa entregada correctamente."
        )

    except Exception as error:

        conexion.rollback()

        return False, (
            f"Error al entregar recompensa: {error}"
        )

    finally:

        cursor.close()
        conexion.close()
