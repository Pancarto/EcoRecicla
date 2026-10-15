# ============================================================
# ECORECICLA - BLUEPRINT ADMINISTRATIVO
# ============================================================

from flask import (
    Blueprint,
    render_template,
    session,
    redirect,
    url_for,
    request,
    flash
)

from services.empresa_service import (
    obtener_empresas
)

from services.admin_recompensa_service import (
    obtener_todas_recompensas,
    actualizar_stock
)

from services.admin_usuario_service import (
    obtener_usuarios
)

from services.dashboard_service import (
    obtener_estadisticas_generales
)

from utils.admin import (
    admin_required
)


# ============================================================
# BLUEPRINT
# ============================================================

admin_bp = Blueprint(
    "admin",
    __name__,
    url_prefix="/admin"
)


# ============================================================
# PANEL PRINCIPAL
# ============================================================

@admin_bp.route("/")
@admin_required
def panel():

    estadisticas = obtener_estadisticas_generales()

    return render_template(
        "admin/panel.html",
        estadisticas=estadisticas
    )


# ============================================================
# EMPRESAS ALIADAS
# ============================================================

@admin_bp.route("/empresas")
@admin_required
def empresas():

    empresas = obtener_empresas()

    return render_template(
        "admin/empresas.html",
        empresas=empresas
    )


# ============================================================
# RECOMPENSAS
# ============================================================

@admin_bp.route("/recompensas")
@admin_required
def recompensas():

    recompensas = obtener_todas_recompensas()

    return render_template(
        "admin/recompensas.html",
        recompensas=recompensas
    )


# ============================================================
# ACTUALIZAR STOCK
# ============================================================

@admin_bp.route(
    "/recompensas/stock/<int:id_recompensa>",
    methods=["POST"]
)
@admin_required
def cambiar_stock(id_recompensa):

    try:

        stock = int(
            request.form.get("stock")
        )

        if stock < 0:
            raise ValueError

    except (TypeError, ValueError):

        flash(
            "El stock debe ser un número válido.",
            "error"
        )

        return redirect(
            url_for("admin.recompensas")
        )


    actualizado = actualizar_stock(
        id_recompensa,
        stock
    )


    if actualizado:

        flash(
            "Stock actualizado correctamente.",
            "success"
        )

    else:

        flash(
            "No fue posible actualizar el stock.",
            "error"
        )


    return redirect(
        url_for("admin.recompensas")
    )


# ============================================================
# USUARIOS
# ============================================================

@admin_bp.route("/usuarios")
@admin_required
def usuarios():

    usuarios = obtener_usuarios()

    return render_template(
        "admin/usuarios.html",
        usuarios=usuarios
    )