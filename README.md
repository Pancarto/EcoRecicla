# EcoRecicla - preparación para Render

Aplicación Flask con plantillas HTML/Jinja2, archivos estáticos y MySQL.

## Archivos de despliegue añadidos/ajustados
- `Procfile`: arranque con Gunicorn.
- `config/config.py`: lee configuración desde variables de entorno.
- `database/conexion.py`: conexión MySQL mediante variables de entorno.
- `.gitignore`: excluye `.env`, entornos virtuales y archivos temporales.
- `requirements.txt`: incluye Gunicorn.

## Importante: base de datos
`database/ecorecicla.sql` solo crea la base de datos vacía; no contiene las tablas del sistema.
Antes de desplegar, exporta desde phpMyAdmin de XAMPP la base `ecorecicla` completa
(estructura y datos necesarios) y guárdala de forma privada. No publiques datos personales
ni contraseñas en el repositorio.

Render no ofrece MySQL administrado en su plan gratuito. Necesitas una base MySQL compatible
accesible desde Render o migrar el esquema/datos a PostgreSQL (eso sí requeriría adaptar código).
No cambies el motor hasta decidir el proveedor y verificar compatibilidad.

## Configuración en Render
- Build command: `pip install -r requirements.txt`
- Start command: `gunicorn run:app`
- Environment: `SECRET_KEY`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`.
- Si el proveedor MySQL exige un certificado CA, configura `DB_SSL_CA` según sus instrucciones.

## Seguridad
Nunca subas `.env`, contraseñas, claves de sesión ni una copia de la base de datos al repositorio público.
Antes de producción, confirma que `SECRET_KEY` sea una clave aleatoria fuerte y distinta de la de desarrollo.
