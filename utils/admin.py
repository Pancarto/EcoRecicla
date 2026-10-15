# ============================================================
# ECORECICLA - CONTROL DE ACCESO ADMINISTRATIVO
# ============================================================

from functools import wraps

from flask import (
    session,
    redirect,
    url_for,
    flash
)


# ============================================================
# ADMINISTRADOR PRINCIPAL
# ============================================================

ADMIN_PRINCIPAL = "acevedojeisson217@gmail.com"


# ============================================================
# VERIFICAR SI EL USUARIO ES ADMINISTRADOR
# ============================================================

def es_administrador():

    correo = session.get("correo")

    if not correo:
        return False

    return correo.lower() == ADMIN_PRINCIPAL.lower()


# ============================================================
# PROTEGER RUTAS ADMINISTRATIVAS
# ============================================================

def admin_required(func):

    @wraps(func)
    def decorador(*args, **kwargs):

        # Usuario no autenticado
        if "usuario_id" not in session:

            return redirect(
                url_for("auth.login")
            )

        # Usuario autenticado pero no administrador
        if not es_administrador():

            flash(
                "No tienes permisos para acceder al panel administrativo.",
                "error"
            )

            return redirect(
                url_for("main.dashboard")
            )

        return func(*args, **kwargs)

    return decorador