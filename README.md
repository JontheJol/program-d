# Métodos Numéricos

Esta aplicación web implementa tres métodos numéricos comunes utilizados en cálculo y análisis numérico:

- **Método de Euler Mejorado**: Para resolver ecuaciones diferenciales ordinarias
- **Método de Runge-Kutta**: Método de 4to orden para resolver ecuaciones diferenciales con alta precisión
- **Método de Newton-Raphson**: Para encontrar raíces de ecuaciones no lineales

## Requisitos

- Python 3.6 o superior
- Flask
- SymPy
- NumPy
# Para Unstalar dependencias
pip install -r requirements.txt
## En caso de querer actualizar los paquetes correr 
pip freeze > requirements.txt
## Instalación

1. Clona este repositorio:
2. Crea un entorno virtual (recomendado):
   2.5 Activa el entorno virtual:
    - En Windows:
      ```
      venv\Scripts\activate
      ```
    - En Linux/macOS:
      ```
      source venv/bin/activate
      ```

3. Instala las dependencias:
    pip install -r requirements.txt


## Cómo ejecutar la aplicación

1. Asegúrate de que el entorno virtual esté activado
2. Ejecuta la aplicación Flask:
    python app.py
3. Abre tu navegador web y ve a:
    http://localhost:5000/

## Uso de la aplicación

### Método de Euler Mejorado
1. Navega a la pestaña "Euler Mejorado"
2. Ingresa una función en términos de x e y (por ejemplo: `x + y`)
3. Proporciona los valores iniciales, paso y valor final
4. Haz clic en "Calcular"

### Método de Runge-Kutta
1. Navega a la pestaña "Runge-Kutta"
2. Ingresa una función en términos de x e y
3. Proporciona los valores iniciales, paso y valor final
4. Haz clic en "Calcular"

### Método de Newton-Raphson
1. Navega a la pestaña "Newton-Raphson"
2. Ingresa una función en términos de x (por ejemplo: `x**2 - 4`)
3. Proporciona el valor inicial (x₀) y la tolerancia
4. Haz clic en "Calcular"
5. Observa la función, su derivada y las iteraciones


## Creación de un ejecutable

Para crear un ejecutable independiente, puedes usar PyInstaller:

### Para Linux:

1. Instala PyInstaller:
```bash
pip install pyinstaller
```

2. Genera el ejecutable:
```bash
pyinstaller --onefile --add-data "templates:templates" --add-data "static:static" --name MetodosNumericos run.py
```

El ejecutable estará disponible en la carpeta `dist/MetodosNumericos`

### Para Windows:

1. En Windows, instala PyInstaller:
```cmd
pip install pyinstaller
```

2. Genera el ejecutable para Windows:
```cmd
pyinstaller --onefile --add-data "templates;templates" --add-data "static;static" --name MetodosNumericos.exe run.py
```

**Nota importante**: En Windows se usa `;` (punto y coma) en lugar de `:` (dos puntos) para separar origen y destino en `--add-data`.

El ejecutable estará disponible en la carpeta `dist/MetodosNumericos.exe`

### Opciones adicionales para Windows:

Para crear un ejecutable sin ventana de consola (solo GUI):
```cmd
pyinstaller --onefile --windowed --add-data "templates;templates" --add-data "static;static" --name MetodosNumericos.exe run.py
```

Para incluir un icono personalizado:
```cmd
pyinstaller --onefile --windowed --icon=icono.ico --add-data "templates;templates" --add-data "static;static" --name MetodosNumericos.exe run.py
```

## Cómo ejecutar los ejecutables

### En Linux:

1. **Desde terminal**:
   ```bash
   cd dist/
   ./MetodosNumericos
   ```

2. **Desde el explorador de archivos**:
   - Navega a la carpeta `dist/`
   - Haz doble clic en `MetodosNumericos`
   - Si no funciona, dale permisos de ejecución primero:
     ```bash
     chmod +x dist/MetodosNumericos
     ```

### En Windows:

1. **Desde símbolo del sistema (CMD)**:
   ```cmd
   cd dist
   MetodosNumericos.exe
   ```

2. **Desde PowerShell**:
   ```powershell
   cd dist
   .\MetodosNumericos.exe
   ```

3. **Desde el explorador de Windows**:
   - Navega a la carpeta `dist\`
   - Haz doble clic en `MetodosNumericos.exe`

### Comportamiento al ejecutar:

1. **Se abre automáticamente**: El navegador web predeterminado se abrirá después de 1.5 segundos
2. **URL de acceso**: La aplicación estará disponible en `http://localhost:5000/`
3. **Ventana de terminal**: 
   - En Linux: Se mostrará una ventana de terminal con información del servidor
   - En Windows: Dependiendo de cómo fue compilado, puede o no mostrar ventana de consola

### Para cerrar la aplicación:

- **Cierra el navegador** y **presiona Ctrl+C** en la terminal/consola
- O simplemente **cierra la ventana de terminal/consola**

### Distribución:

- **Linux**: El ejecutable `MetodosNumericos` solo funciona en sistemas Linux de 64 bits
- **Windows**: El ejecutable `MetodosNumericos.exe` funciona en Windows 7/8/10/11 de 64 bits
- **No requiere**: Python ni dependencias instaladas en el sistema destino
- **Tamaño**: Aproximadamente 8-15 MB (incluye todo lo necesario)

---

## 🚀 CI/CD y Deployment

Este proyecto incluye un pipeline completo de CI/CD (Integración y Entrega Continua) usando **GitHub Actions** y **Docker**.

### 🏗️ Arquitectura de CI/CD

El proyecto soporta múltiples ambientes:
- **Desarrollo** (`development`) - Puerto 5000
- **Pruebas** (`test`) - Puerto 5001  
- **Preproducción** (`staging`) - Puerto 5002
- **Producción** (`production`) - Puerto 5003

### 📋 Pipeline Automatizado

El pipeline se ejecuta automáticamente en cada push y pull request:

1. **🧪 Testing & Quality**: 
   - Tests unitarios con pytest
   - Análisis de código con flake8
   - Verificación de formato con black
   - Reporte de cobertura

2. **📦 Build**: 
   - Construcción de imagen Docker
   - Publicación en GitHub Container Registry
   - Soporte para múltiples arquitecturas (amd64, arm64)

3. **🚀 Deploy Automático**:
   - **Test**: Deploy automático desde rama `develop`
   - **Staging**: Deploy automático desde rama `main`
   - **Production**: Deploy manual con aprobación requerida

### 🐳 Docker y Containerización

#### Desarrollo Local con Docker

```bash
# Desarrollo con hot-reload
docker-compose up

# Ejecutar en modo test
docker-compose --profile test up app-test

# Ejecutar en modo staging
docker-compose --profile staging up app-staging

# Ejecutar en modo production
docker-compose --profile production up app-production
```

#### Construcción Manual

```bash
# Construir imagen
docker build -t metodos-numericos .

# Ejecutar contenedor
docker run -p 5000:5000 metodos-numericos
```

### 🔧 Scripts de Deployment

El proyecto incluye scripts automatizados para cada ambiente:

```bash
# Deploy a ambiente de pruebas
./scripts/deploy-test.sh

# Deploy a preproducción  
./scripts/deploy-staging.sh

# Deploy a producción (requiere confirmación)
./scripts/deploy-production.sh
```

### 🧪 Testing

#### Ejecutar Tests Localmente

```bash
# Instalar dependencias de desarrollo
pip install pytest pytest-cov pytest-flask black flake8

# Ejecutar todos los tests
pytest tests/ -v

# Tests con reporte de cobertura
pytest tests/ --cov=app --cov-report=html

# Verificar formato de código
black --check .

# Análisis de código
flake8 .
```

#### Estructura de Tests

```
tests/
├── __init__.py
├── conftest.py                 # Configuración de fixtures
├── test_metodos_numericos.py   # Tests de algoritmos
└── test_flask_app.py          # Tests de endpoints Flask
```

### 📊 Ambientes y Configuración

#### Variables de Ambiente

Cada ambiente tiene su archivo de configuración:

- `config/.env.development` - Desarrollo
- `config/.env.test` - Pruebas automatizadas  
- `config/.env.staging` - Preproducción
- `config/.env.production` - Producción

#### Configuración por Ambiente

```bash
# Variables importantes
FLASK_ENV=production|development|testing
FLASK_DEBUG=True|False
FLASK_HOST=0.0.0.0
FLASK_PORT=5000
SECRET_KEY=tu-clave-secreta
```

### 🔒 Seguridad y Buenas Prácticas

- ✅ **Contenedor sin privilegios de root**
- ✅ **Variables de ambiente para configuración sensible**
- ✅ **Imágenes Docker multi-arquitectura**
- ✅ **Health checks automáticos**
- ✅ **Blue-Green deployment en producción**
- ✅ **Rollback automático en caso de falla**
- ✅ **Limpieza automática de imágenes antiguas**

### 🔄 Workflow de Desarrollo

1. **Desarrollo Local**:
   ```bash
   git checkout develop
   # Hacer cambios
   docker-compose up  # Para probar localmente
   ```

2. **Testing**:
   ```bash
   pytest tests/  # Ejecutar tests
   git commit -m "feat: nueva funcionalidad"
   git push origin develop  # Deploy automático a test
   ```

3. **Preproducción**:
   ```bash
   git checkout main
   git merge develop
   git push origin main  # Deploy automático a staging
   ```

4. **Producción**:
   - Ir a GitHub Actions
   - Aprobar deployment manual a producción
   - O ejecutar: `./scripts/deploy-production.sh`

### 📈 Monitoreo y Logs

```bash
# Ver logs en tiempo real
docker logs -f metodos-numericos-production

# Monitorear recursos
docker stats metodos-numericos-production

# Health check manual
curl http://localhost:5003/
```

### 🚨 Rollback de Emergencia

En caso de problemas en producción:

```bash
# Ver contenedores disponibles
docker ps -a

# Rollback a versión anterior
docker stop metodos-numericos-production
docker start metodos-numericos-production-backup-YYYYMMDD-HHMMSS
```

### 📚 Comandos Útiles

```bash
# Ver todas las imágenes
docker images metodos-numericos

# Limpiar sistema Docker
docker system prune -a

# Ver logs de build en GitHub Actions
# Ir a: https://github.com/tu-usuario/program-d/actions

# Descargar imagen desde registry
docker pull ghcr.io/tu-usuario/program-d/metodos-numericos:latest
```

