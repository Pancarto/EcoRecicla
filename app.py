# ============================================================
# ECORECICLA - CONFIGURACIÓN PRINCIPAL
# ============================================================

from flask import Flask


def create_app():

    # Crear aplicación
    app = Flask(__name__)

    # Clave de sesión
    app.config["SECRET_KEY"] = "ecorecicla-clave-desarrollo"

    # ========================================================
    # IMPORTAR BLUEPRINTS
    # ========================================================

    from blueprints.main.routes import main_bp
    from blueprints.auth.routes import auth_bp
    from blueprints.reciclaje.routes import reciclaje_bp
    from blueprints.recompensa.routes import recompensa_bp
    from blueprints.canje.routes import canje_bp
    from blueprints.validacion.routes import validacion_bp
    from blueprints.empresa.routes import empresa_bp


    # ========================================================
    # REGISTRAR BLUEPRINTS
    # ========================================================

    app.register_blueprint(main_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(reciclaje_bp)
    app.register_blueprint(recompensa_bp)
    app.register_blueprint(canje_bp)
    app.register_blueprint(validacion_bp)
    app.register_blueprint(empresa_bp)

    # ========================================================
    # RETORNAR APLICACIÓN
    # ========================================================
    print("BLUEPRINTS REGISTRADOS:")
    print(app.url_map)
    return app