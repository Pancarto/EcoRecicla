# ============================================================
# ECORECICLA - BLUEPRINT PRINCIPAL
# ============================================================

from flask import (
    Blueprint,
    render_template,
    session,
    redirect,
    url_for
)

from services.puntos_service import (
    obtener_saldo_usuario,
    obtener_movimientos_usuario,
    obtener_estadisticas_usuario
)
from services.canje_service import (
    obtener_canjes_usuario
)


main_bp = Blueprint("main", __name__)


# ============================================================
# INICIO
# ============================================================

@main_bp.route("/")
def inicio():

    return render_template("inicio.html")


# ============================================================
# DASHBOARD
# ============================================================

@main_bp.route("/dashboard")
def dashboard():

    if "usuario_id" not in session:

        return redirect(
            url_for("auth.login")
        )

    id_usuario = session["usuario_id"]

    saldo = obtener_saldo_usuario(id_usuario)

    movimientos = obtener_movimientos_usuario(
        id_usuario
    )

    estadisticas = obtener_estadisticas_usuario(
        id_usuario
    )
    # ========================================================
    # ÚLTIMOS CANJES
    # ========================================================
    #
    # El servicio ya devuelve los canjes ordenados
    # del más reciente al más antiguo.
    #
    # No modificamos la información de la base de datos.
    # Solo enviamos los registros al dashboard.
    #
    canjes = obtener_canjes_usuario(
        id_usuario
    )



    return render_template(
        "usuario/dashboard.html",
        saldo=saldo,
        movimientos=movimientos,
        estadisticas=estadisticas,
        canjes=canjes
    )