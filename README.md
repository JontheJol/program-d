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


## Creación de un ejecutable (opcinal,no funcioa siempre)

Para crear un ejecutable independiente, puedes usar PyInstaller:

1. Instala PyInstaller:
pip install pyinstaller


2. Crea un archivo `run.py`:
```python
import webbrowser
from threading import Timer
from app import app

def open_browser():
    webbrowser.open_new('http://localhost:5000/')

if __name__ == '__main__':
    Timer(1.5, open_browser).start()
    app.run(host='localhost', port=5000)

|pyinstaller --onefile --add-data "templates:templates" --add-data "static:static" --name MetodosNumericos run.py
# El ejecutable se encontrara en 
El ejecutable estará disponible en la carpeta dist/

