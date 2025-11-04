# 🔐 SECURITY.md - Guía de Seguridad

## ⚠️ **ARCHIVOS SENSIBLES - NO SUBIR A GIT**

### ❌ **NUNCA subir estos tipos de archivos:**

```bash
# Variables de ambiente con valores reales
.env
.env.local
.env.production
.env.staging
.env.test
.env.development

# Claves y certificados
*.key
*.pem
*.crt
*.p12
*.pfx
id_rsa*

# Configuraciones con credenciales
config/database.yml (con passwords reales)
config/secrets.yml
docker-compose.override.local.yml

# Archivos de backup con datos sensibles
*.backup
database.sql
```

## ✅ **SÍ puedes subir (proyecto académico):**

```bash
# Templates sin valores reales
.env.*.template
config/README.md
scripts/deploy-*.sh (sin credenciales)
.github/workflows/ci-cd.yml
Dockerfile
docker-compose.yml
```

## 🔒 **Buenas Prácticas Implementadas**

### 1. **Variables de Ambiente**
- ✅ Templates sin valores sensibles
- ✅ `.gitignore` configurado correctamente
- ✅ Script de setup automático

### 2. **Docker Security**
- ✅ Usuario no-root en contenedores
- ✅ Variables de ambiente externas
- ✅ `.dockerignore` configurado

### 3. **CI/CD Security**
- ✅ Secrets manejados por GitHub Actions
- ✅ Validaciones pre-deployment
- ✅ Rollback automático

## 🛠️ **Configuración Segura**

### Para Desarrollo Local:
```bash
# 1. Configurar ambiente
make setup-env

# 2. Editar archivos .env con valores locales (NO subir a git)
vim config/.env.development

# 3. Generar SECRET_KEY segura
python -c "import secrets; print(secrets.token_hex(32))"
```

### Para Producción Real:
1. **Usar servicios de secretos:**
   - AWS Parameter Store
   - Azure Key Vault  
   - Google Secret Manager
   - GitHub Secrets

2. **Variables de ambiente del sistema:**
```bash
export SECRET_KEY="tu-clave-super-segura"
export DATABASE_URL="postgresql://user:pass@host:5432/db"
```

## 🚨 **Si Accidentalmente Subes Secretos**

### Inmediatamente:
1. **Cambiar todas las credenciales comprometidas**
2. **Eliminar del historial de git:**
```bash
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch config/.env.production' \
--prune-empty --tag-name-filter cat -- --all
```
3. **Forzar push:**
```bash
git push origin --force --all
```

## 📋 **Checklist Pre-Commit**

Antes de cada `git commit`, verifica:

- [ ] ¿Hay archivos `.env` (sin .template) en el commit?
- [ ] ¿Hay passwords/keys/tokens en el código?
- [ ] ¿Los archivos de configuración solo tienen valores de ejemplo?
- [ ] ¿El `.gitignore` está actualizado?

### Script de verificación:
```bash
# Verificar que no hay secretos
git diff --cached --name-only | grep -E '\.(env|key|pem|crt)$' && echo "⚠️ REVISAR ARCHIVOS SENSIBLES" || echo "✅ OK"
```

## 🎓 **Para Proyecto Académico**

Este proyecto es **académico y público**, por lo que:

### ✅ **Está OK subir:**
- Scripts de deployment (sin credenciales reales)
- Configuración de CI/CD
- Docker files
- Templates de configuración
- Documentación completa

### ❌ **NUNCA subir (ni en proyectos académicos):**
- Claves reales (aunque sean de prueba)
- Passwords
- API keys
- Certificados
- Datos de base de datos

## 📚 **Recursos Adicionales**

- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Docker Security](https://docs.docker.com/engine/security/)

---

**Recuerda:** Aunque sea un proyecto académico, practicar buena seguridad desde el principio es esencial para desarrollar buenos hábitos profesionales. 🎯