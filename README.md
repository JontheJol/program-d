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

