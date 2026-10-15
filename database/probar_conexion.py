# ============================================================
# ECORECICLA - PRUEBA DE CONEXIÓN
# ============================================================

import sys
import os

# Agrega la carpeta principal del proyecto al sistema de Python
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from database.conexion import obtener_conexion


conexion = None

try:
    conexion = obtener_conexion()

    if conexion.is_connected():
        print("======================================")
        print(" CONEXIÓN EXITOSA")
        print(" EcoRecicla -> MySQL")
        print("======================================")

except Exception as error:
    print("======================================")
    print(" ERROR DE CONEXIÓN")
    print(error)
    print("======================================")

finally:
    if conexion and conexion.is_connected():
        conexion.close()
        print("Conexión cerrada correctamente.")