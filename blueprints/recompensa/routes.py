# ============================================================
# ECORECICLA - BLUEPRINT DE RECOMPENSAS
# ============================================================

from flask import (
    Blueprint,
    render_template,
    session,
    redirect,
    url_for
)

from services.recompensa_service import (
    obtener_recompensas_disponibles
)

from services.puntos_service import (
    obtener_saldo_usuario
)


recompensa_bp = Blueprint(
    "recompensa",
    __name__,
    url_prefix="/recompensas"
)


# ============================================================
# CATÁLOGO
# ============================================================

@recompensa_bp.route("/")
def catalogo():

    if "usuario_id" not in session:

        return redirect(
            url_for("auth.login")
        )

    recompensas = obtener_recompensas_disponibles()

    saldo = obtener_saldo_usuario(
        session["usuario_id"]
    )

    return render_template(
        "usuario/recompensas.html",
        recompensas=recompensas,
        saldo=saldo
    )