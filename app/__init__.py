# ============================================================
# ECORECICLA - CREACIÓN DE LA APLICACIÓN FLASK
# ============================================================

from flask import Flask
from config.config import Config


def create_app():
    """Crea y configura la aplicación principal."""

    app = Flask(
        __name__,
        template_folder="../templates",
        static_folder="../static",
    )

    app.config.from_object(Config)
    from blueprints.main.routes import main_bp
    from blueprints.auth.routes import auth_bp
    from blueprints.reciclaje.routes import reciclaje_bp
    from blueprints.recompensa.routes import recompensa_bp
    from blueprints.canje.routes import canje_bp
    from blueprints.validacion.routes import validacion_bp
    from blueprints.empresa.routes import empresa_bp
    from blueprints.admin.routes import admin_bp

    app.register_blueprint(main_bp)
    app.register_blueprint(auth_bp, url_prefix="/auth")
    app.register_blueprint(reciclaje_bp)
    app.register_blueprint(recompensa_bp)
    app.register_blueprint(canje_bp)
    app.register_blueprint(validacion_bp)
    app.register_blueprint(empresa_bp)
    app.register_blueprint(admin_bp)

    return app
