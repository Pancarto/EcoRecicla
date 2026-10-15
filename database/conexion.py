import mysql.connector
from mysql.connector import Error
from config.config import Config

def obtener_conexion():
    """Abre una conexión a la base de datos configurada por variables de entorno."""
    params = {
        "host": Config.DB_HOST,
        "port": Config.DB_PORT,
        "user": Config.DB_USER,
        "password": Config.DB_PASSWORD,
        "database": Config.DB_NAME,
        "connection_timeout": 10,
    }
    if Config.DB_SSL_CA:
        params["ssl_ca"] = Config.DB_SSL_CA
        params["ssl_verify_cert"] = True
    try:
        return mysql.connector.connect(**params)
    except Error as error:
        # No registrar contraseñas ni parámetros de conexión.
        raise RuntimeError(f"No fue posible conectar con MySQL: {error}") from error
