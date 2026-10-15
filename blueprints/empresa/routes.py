# ============================================================
# ECORECICLA - BLUEPRINT EMPRESA ALIADA
# ============================================================

from flask import (
    Blueprint,
    render_template,
    session,
    redirect,
    url_for
)


empresa_bp = Blueprint(
    "empresa",
    __name__,
    url_prefix="/empresa"
)


# ============================================================
# PANEL DE EMPRESA
# ============================================================

@empresa_bp.route("/")
def dashboard():

    if "usuario_id" not in session:
        return redirect(
            url_for("auth.login")
        )

    return render_template(
        "empresa/dashboard.html"
    )