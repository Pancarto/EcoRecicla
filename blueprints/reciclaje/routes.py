# ============================================================
# ECORECICLA - BLUEPRINT DE RECICLAJE
# ============================================================

from flask import (
    Blueprint,
    render_template,
    request,
    redirect,
    url_for,
    session,
    flash
)

from services.reciclaje_service import (
    obtener_materiales,
    registrar_reciclaje,
    obtener_reciclajes_usuario
)


reciclaje_bp = Blueprint(
    "reciclaje",
    __name__,
    url_prefix="/reciclaje"
)


# ============================================================
# REGISTRAR RECICLAJE
# ============================================================

@reciclaje_bp.route("/registrar", methods=["GET", "POST"])
def reciclar():

    if "usuario_id" not in session:

        return redirect(
            url_for("auth.login")
        )

    materiales = obtener_materiales()

    if request.method == "POST":

        id_tipo_material = int(
            request.form.get("id_tipo_material")
        )

        peso = float(
            request.form.get("peso")
        )

        # Máquina piloto EcoRecicla San Mateo
        id_maquina = 1

        exitoso, resultado = registrar_reciclaje(
            session["usuario_id"],
            id_maquina,
            id_tipo_material,
            peso
        )

        if not exitoso:

            flash(resultado, "error")

            return render_template(
                "usuario/reciclar.html",
                materiales=materiales
            )

        flash(
            f"Reciclaje registrado. "
            f"Ganaste {resultado['puntos']} puntos.",
            "success"
        )

        return redirect(
            url_for("main.dashboard")
        )

    return render_template(
        "usuario/reciclar.html",
        materiales=materiales
    )


# ============================================================
# HISTORIAL
# ============================================================

@reciclaje_bp.route("/historial")
def historial():

    if "usuario_id" not in session:

        return redirect(
            url_for("auth.login")
        )

    reciclajes = obtener_reciclajes_usuario(
        session["usuario_id"]
    )

    return render_template(
        "usuario/historial.html",
        reciclajes=reciclajes
    )