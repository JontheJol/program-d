# REPORTE DE ERRORES Y TESTING - PROYECTO MÉTODOS NUMÉRICOS

## INFORMACIÓN DEL PROYECTO
- **Nombre**: Métodos Numéricos (Flask Web App)
- **Fecha de Testing**: 16 de Octubre, 2025
- **Tester**: Equipo QA Simulado
- **Versión**: 1.0
- **Tecnologías**: Python 3.10, Flask, SymPy, NumPy

---

## a) ERRORES PROVOCADOS Y EVIDENCIA

### ERROR 1: SyntaxError - Paréntesis no cerrado

**🔴 DESCRIPCIÓN DEL ERROR:**
```python
# Línea 5 en app.py
app = Flask(__name__  # ERROR INTENCIONAL: Falta paréntesis de cierre
```

**🔴 EVIDENCIA DEL ERROR:**
```
File "/home/JonJolf/Classes/Gestion/program-d/app.py", line 5
    app = Flask(__name__  # ERROR INTENCIONAL: Falta paréntesis de cierre
               ^
SyntaxError: '(' was never closed
```

**📋 ANÁLISIS:**
- **Tipo**: Error de sintaxis (parsing)
- **Severidad**: CRÍTICA - La aplicación no puede ejecutarse
- **Causa**: Paréntesis de apertura sin su correspondiente cierre
- **Detección**: En tiempo de compilación (antes de ejecutar)

**✅ SOLUCIÓN:**
```python
# CORRECTO:
app = Flask(__name__)
```

---

### ERROR 2: ModuleNotFoundError - Importación inexistente

**🔴 DESCRIPCIÓN DEL ERROR:**
```python
# Línea 4 en app.py
import biblioteca_inexistente  # ERROR INTENCIONAL: Módulo que no existe
```

**🔴 EVIDENCIA DEL ERROR:**
```
Traceback (most recent call last):
  File "/home/JonJolf/Classes/Gestion/program-d/app.py", line 4, in <module>
    import biblioteca_inexistente  # ERROR INTENCIONAL: Módulo que no existe
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
ModuleNotFoundError: No module named 'biblioteca_inexistente'
```

**📋 ANÁLISIS:**
- **Tipo**: Error de importación
- **Severidad**: CRÍTICA - La aplicación no puede ejecutarse
- **Causa**: Intento de importar un módulo que no existe
- **Detección**: En tiempo de carga del módulo

**✅ SOLUCIÓN:**
```python
# ELIMINAR la línea problemática o instalar el módulo correcto
# import biblioteca_inexistente  # ← ELIMINAR ESTA LÍNEA
```

---

### ERROR 3: ZeroDivisionError - División por cero

**🔴 DESCRIPCIÓN DEL ERROR:**
```python
# Línea 18 en app.py (función euler_mejorado)
y_siguiente = y_actual + h * (k1 + k2) / 0  # ERROR INTENCIONAL: División por cero
```

**🔴 EVIDENCIA DEL ERROR:**
```
ZeroDivisionError: float division by zero
```

**📋 ANÁLISIS:**
- **Tipo**: Error en tiempo de ejecución
- **Severidad**: ALTA - Causa fallo durante el cálculo
- **Causa**: División por cero en operación matemática
- **Detección**: Cuando el usuario ejecuta el método de Euler

**✅ SOLUCIÓN:**
```python
# CORRECTO:
y_siguiente = y_actual + h * (k1 + k2) / 2  # Dividir por 2, no por 0
```

---

## PROCESO DE DETECCIÓN DE ERRORES

### 1. **Errores de Sintaxis**
- **Cuándo se detectan**: Al intentar ejecutar el archivo Python
- **Herramientas**: Intérprete de Python, IDEs, linters
- **Prevención**: Usar un IDE con syntax highlighting

### 2. **Errores de Importación**
- **Cuándo se detectan**: Al cargar el módulo
- **Herramientas**: Python, verificación de dependencies
- **Prevención**: Verificar requirements.txt y entorno virtual

### 3. **Errores de Ejecución**
- **Cuándo se detectan**: Durante la ejecución de funciones específicas
- **Herramientas**: Testing unitario, debugging
- **Prevención**: Validación de entrada, testing exhaustivo

---

## ESTADO ACTUAL
- ❌ Aplicación no funcional debido a errores introducidos
- 📝 Errores documentados y analizados
- 🔄 Pendiente: Corrección de errores y testing completo
