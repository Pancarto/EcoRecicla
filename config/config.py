import os
from dotenv import load_dotenv

# En local carga .env; en Render las variables se configuran desde el panel.
load_dotenv()

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "solo-desarrollo-cambiar-esta-clave")
    DB_HOST = os.environ.get("DB_HOST", "127.0.0.1")
    DB_PORT = int(os.environ.get("DB_PORT", "3306"))
    DB_USER = os.environ.get("DB_USER", "root")
    DB_PASSWORD = os.environ.get("DB_PASSWORD", "")
    DB_NAME = os.environ.get("DB_NAME", "ecorecicla")
    DB_SSL_CA = os.environ.get("DB_SSL_CA", "")
