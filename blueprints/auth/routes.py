# ============================================================
# ECORECICLA - AUTENTICACIÓN
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

from services.auth_service import (
    registrar_usuario,
    autenticar_usuario,
    obtener_tipos_documento
)


auth_bp = Blueprint("auth", __name__)


# ============================================================
# LOGIN
# ============================================================

@auth_bp.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        correo = request.form.get("correo", "").strip()
        password = request.form.get("password", "")

        if not correo or not password:

            flash(
                "Debes ingresar correo y contraseña.",
                "error"
            )

            return render_template("auth/login.html")

        usuario = autenticar_usuario(
            correo,
            password
        )

        if not usuario:

            flash(
                "Correo o contraseña incorrectos.",
                "error"
            )

            return render_template("auth/login.html")

        # ----------------------------------------------------
        # Crear sesión
        # ----------------------------------------------------

        session.clear()

        session["usuario_id"] = usuario["id_usuario"]
        session["rol_id"] = usuario["id_rol"]
        session["nombre"] = usuario["nombres"]
        session["correo"] = usuario["correo"]

        return redirect(
            url_for("main.dashboard")
        )

    return render_template("auth/login.html")


# ============================================================
# REGISTRO
# ============================================================

@auth_bp.route("/registro", methods=["GET", "POST"])
def registro():

    tipos_documento = obtener_tipos_documento()

    if request.method == "POST":

        id_tipo_documento = request.form.get(
            "id_tipo_documento"
        )

        numero_documento = request.form.get(
            "numero_documento",
            ""
        ).strip()

        nombres = request.form.get(
            "nombres",
            ""
        ).strip()

        apellidos = request.form.get(
            "apellidos",
            ""
        ).strip()

        correo = request.form.get(
            "correo",
            ""
        ).strip().lower()

        telefono = request.form.get(
            "telefono",
            ""
        ).strip()

        password = request.form.get(
            "password",
            ""
        )

        confirmar_password = request.form.get(
            "confirmar_password",
            ""
        )

        # ----------------------------------------------------
        # Validaciones
        # ----------------------------------------------------

        if not all([
            id_tipo_documento,
            numero_documento,
            nombres,
            apellidos,
            correo,
            password,
            confirmar_password
        ]):

            flash(
                "Completa todos los campos obligatorios.",
                "error"
            )

            return render_template(
                "auth/registro.html",
                tipos_documento=tipos_documento
            )

        if password != confirmar_password:

            flash(
                "Las contraseñas no coinciden.",
                "error"
            )

            return render_template(
                "auth/registro.html",
                tipos_documento=tipos_documento
            )

        if len(password) < 8:

            flash(
                "La contraseña debe tener mínimo 8 caracteres.",
                "error"
            )

            return render_template(
                "auth/registro.html",
                tipos_documento=tipos_documento
            )

        # ----------------------------------------------------
        # Registrar
        # ----------------------------------------------------

        exitoso, mensaje = registrar_usuario(
            id_tipo_documento,
            numero_documento,
            nombres,
            apellidos,
            correo,
            telefono,
            password
        )

        if not exitoso:

            flash(mensaje, "error")

            return render_template(
                "auth/registro.html",
                tipos_documento=tipos_documento
            )

        flash(
            "Cuenta creada correctamente. Ahora puedes iniciar sesión.",
            "success"
        )

        return redirect(
            url_for("auth.login")
        )

    return render_template(
        "auth/registro.html",
        tipos_documento=tipos_documento
    )


# ============================================================
# CERRAR SESIÓN
# ============================================================

@auth_bp.route("/logout")
def logout():

    session.clear()

    flash(
        "Sesión cerrada correctamente.",
        "success"
    )

    return redirect(
        url_for("main.inicio")
    )