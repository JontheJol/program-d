# 🔐 Configuración de Ambientes

Esta carpeta contiene archivos de configuración para diferentes ambientes de la aplicación.

## ⚠️ IMPORTANTE - Seguridad

### ✅ **Archivos que SÍ están en el repositorio (templates):**
- `.env.development.template`
- `.env.test.template`  
- `.env.staging.template`
- `.env.production.template`

### ❌ **Archivos que NO deben estar en el repositorio:**
- `.env.development`
- `.env.test`
- `.env.staging`
- `.env.production`
- Cualquier archivo `.env` con valores reales

## 🛠️ **Configuración Local**

### Para Desarrollo:
```bash
cd config/
cp .env.development.template .env.development
# Edita .env.development con tus valores locales
```

### Para Testing:
```bash
cp .env.test.template .env.test
# Edita .env.test con valores de prueba
```

### Para Staging/Production:
```bash
cp .env.staging.template .env.staging
cp .env.production.template .env.production
# ⚠️ Configura con valores seguros y NUNCA los subas a git
```

## 🔑 **Variables Importantes**

### Obligatorias:
- `SECRET_KEY`: Clave secreta de Flask (genera una segura)
- `FLASK_ENV`: Ambiente (development/testing/production)
- `FLASK_PORT`: Puerto donde correrá la aplicación

### Opcionales (para extensiones futuras):
- `DATABASE_URL`: URL de base de datos
- `REDIS_URL`: URL de Redis para cache
- `SENTRY_DSN`: Para monitoreo de errores
- `EMAIL_*`: Configuración de email

## 🚀 **Deployment**

En entornos de producción, estas variables deberían configurarse como **variables de ambiente del sistema** o usando servicios como:

- **GitHub Secrets** (para GitHub Actions)
- **AWS Parameter Store**
- **Azure Key Vault**
- **Google Secret Manager**
- **Docker Secrets**
- **Kubernetes Secrets**

## 🎯 **Generar SECRET_KEY Segura**

```python
# En Python
import secrets
print(secrets.token_hex(32))
```

```bash
# En terminal
python -c "import secrets; print(secrets.token_hex(32))"
```

## ✅ **Verificación**

Antes de hacer commit, asegúrate de que:
- Los archivos `.env` reales NO están en git
- Solo los `.template` están en el repositorio
- Ningún valor real/sensible está en los templates