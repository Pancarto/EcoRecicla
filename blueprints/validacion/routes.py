# ============================================================
# ECORECICLA - BLUEPRINT DE VALIDACIÓN
# ============================================================
 
from flask import (
    Blueprint,
    render_template,
    request,
    redirect,
    url_for,
    flash,
    session
)


from services.validacion_service import (
    validar_ticket,
    entregar_recompensa
)

from database.conexion import obtener_conexion


validacion_bp = Blueprint(
    "validacion",
    __name__,
    url_prefix="/validacion"
)




# ============================================================
# VALIDAR TICKET
# ============================================================

@validacion_bp.route("/", methods=["GET", "POST"])
def validar():

    # --------------------------------------------------------
    # SOLO USUARIO AUTORIZADO
    # --------------------------------------------------------

    if session.get("correo") != "acevedojeisson217@gmail.com":

        flash(
            "No tienes permisos para acceder a este módulo.",
            "error"
        )

        return redirect(
            url_for("main.dashboard")
        )

    ticket = None

    if request.method == "POST":

        codigo = request.form.get(
            "codigo_ticket",
            ""
        ).strip().upper()

        if not codigo:

            flash(
                "Debes ingresar un código de ticket.",
                "error"
            )

        else:

            correcto, resultado = validar_ticket(
                codigo
            )

            if correcto:

                ticket = resultado

                flash(
                    "Ticket válido.",
                    "success"
                )

            else:

                flash(
                    resultado,
                    "error"
                )

    return render_template(
        "validacion/validar_ticket.html",
        ticket=ticket
    )
# ============================================================
# CONFIRMAR ENTREGA
# ============================================================

@validacion_bp.route(
    "/entregar/<codigo_ticket>",
    methods=["POST"]
)
def entregar(codigo_ticket):

    correcto, mensaje = entregar_recompensa(
        codigo_ticket
    )

    if correcto:

        flash(
            mensaje,
            "success"
        )

    else:

        flash(
            mensaje,
            "error"
        )

    return redirect(
        url_for("validacion.validar")
    )


# ============================================================
# HISTORIAL DE ENTREGAS
# ============================================================

@validacion_bp.route("/historial")
def historial():

    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    try:

        cursor.execute(
            """
            SELECT
                c.id_canje,
                c.codigo_ticket,
                c.puntos_utilizados,
                c.fecha_canje,
                c.estado,

                r.nombre AS recompensa,

                CONCAT(
                    u.nombres,
                    ' ',
                    u.apellidos
                ) AS usuario

            FROM canjes c

            INNER JOIN recompensas r
                ON c.id_recompensa = r.id_recompensa

            INNER JOIN usuarios u
                ON c.id_usuario = u.id_usuario

            ORDER BY c.fecha_canje DESC
            """
        )

        canjes = cursor.fetchall()

        return render_template(
            "validacion/historial.html",
            canjes=canjes
        )

    finally:

        cursor.close()
        conexion.close()