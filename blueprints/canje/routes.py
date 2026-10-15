# ============================================================
# ECORECICLA - BLUEPRINT DE CANJES
# ============================================================

from flask import (
    Blueprint,
    render_template,
    session,
    redirect,
    url_for,
    flash
)

from services.canje_service import (
    realizar_canje,
    obtener_canjes_usuario
)


canje_bp = Blueprint(
    "canje",
    __name__,
    url_prefix="/canjes"
)


# ============================================================
# REALIZAR CANJE
# ============================================================

@canje_bp.route(
    "/realizar/<int:id_recompensa>",
    methods=["POST"]
)
def realizar(id_recompensa):

    if "usuario_id" not in session:

        return redirect(
            url_for("auth.login")
        )

    exitoso, resultado = realizar_canje(
        session["usuario_id"],
        id_recompensa
    )

    if not exitoso:

        flash(
            resultado,
            "error"
        )

        return redirect(
            url_for("recompensa.catalogo")
        )

    # Guardamos temporalmente el resultado
    # para mostrar el ticket.

    return render_template(
        "usuario/ticket.html",
        canje=resultado
    )


# ============================================================
# HISTORIAL DE CANJES
# ============================================================

@canje_bp.route("/")
def historial():

    if "usuario_id" not in session:

        return redirect(
            url_for("auth.login")
        )

    canjes = obtener_canjes_usuario(
        session["usuario_id"]
    )

    return render_template(
        "usuario/canjes.html",
        canjes=canjes
    )