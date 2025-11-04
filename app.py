from flask import Flask, render_template, request, jsonify
from sympy import symbols, sympify, diff, latex
import numpy as np

app = Flask(__name__)

# Método Euler Mejorado
def euler_mejorado(f, x0, y0, h, xn):
    pasos = []
    x_actual = x0
    y_actual = y0
    paso = 1

    while x_actual <= xn:
        k1 = f(x_actual, y_actual)
        y_pred = y_actual + h * k1
        k2 = f(x_actual + h, y_pred)
        y_siguiente = y_actual + h * (k1 + k2) / 2

        pasos.append({
            "paso": paso,
            "x": round(x_actual, 6),
            "y": round(y_actual, 6),
            "k1": round(k1, 6),
            "y_pred": round(y_pred, 6),
            "k2": round(k2, 6),
            "y_siguiente": round(y_siguiente, 6)
        })

        y_actual = y_siguiente
        x_actual += h
        paso += 1

    return pasos

# Método Runge-Kutta 4to Orden
def runge_kutta_4(f, x0, y0, h, xn):
    pasos = []
    x_actual = x0
    y_actual = y0
    paso = 1

    while x_actual <= xn:
        k1 = f(x_actual, y_actual)
        k2 = f(x_actual + h/2, y_actual + (h/2)*k1)
        k3 = f(x_actual + h/2, y_actual + (h/2)*k2)
        k4 = f(x_actual + h, y_actual + h*k3)
        y_siguiente = y_actual + (h/6)*(k1 + 2*k2 + 2*k3 + k4)

        pasos.append({
            "paso": paso,
            "x": round(x_actual, 6),
            "y": round(y_actual, 6),
            "k1": round(k1, 6),
            "k2": round(k2, 6),
            "k3": round(k3, 6),
            "k4": round(k4, 6),
            "y_siguiente": round(y_siguiente, 6)
        })

        y_actual = y_siguiente
        x_actual += h
        paso += 1

    return pasos

# Método Newton-Raphson
def newton_raphson(f, f_prime, x0, tol, max_iter):
    pasos = []
    x_actual = x0
    iteracion = 1

    while iteracion <= max_iter:
        fx = f(x_actual)
        fpx = f_prime(x_actual)
        x_siguiente = x_actual - fx / fpx
        error = abs(x_siguiente - x_actual)

        pasos.append({
            "iteracion": iteracion,
            "x": round(x_actual, 6),
            "f(x)": round(fx, 6),
            "f'(x)": round(fpx, 6),
            "x_siguiente": round(x_siguiente, 6),
            "error": round(error, 6)
        })

        if error < tol:
            break

        x_actual = x_siguiente
        iteracion += 1

    return pasos

# Rutas
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/calcular_euler', methods=['POST'])
def calcular_euler():
    data = request.json
    x, y = symbols('x y')
    f = sympify(data['funcion'])
    f_np = lambda x_val, y_val: float(f.subs({x: x_val, y: y_val}))
    
    resultados = euler_mejorado(f_np, float(data['x0']), float(data['y0']), float(data['h']), float(data['xn']))
    return jsonify(resultados)

@app.route('/calcular_rk4', methods=['POST'])
def calcular_rk4():
    data = request.json
    x, y = symbols('x y')
    f = sympify(data['funcion'])
    f_np = lambda x_val, y_val: float(f.subs({x: x_val, y: y_val}))
    
    resultados = runge_kutta_4(f_np, float(data['x0']), float(data['y0']), float(data['h']), float(data['xn']))
    return jsonify(resultados)

@app.route('/calcular_newton', methods=['POST'])
def calcular_newton():
    data = request.json
    x = symbols('x')
    f = sympify(data['funcion'])
    f_prime = diff(f, x)
    f_np = lambda x_val: float(f.subs(x, x_val))
    f_prime_np = lambda x_val: float(f_prime.subs(x, x_val))
    
    # Set default max_iter if not provided
    max_iter = int(data.get('max_iter', 100))
    
    resultados = newton_raphson(f_np, f_prime_np, float(data['x0']), float(data['tol']), max_iter)
    return jsonify(resultados)

@app.route('/get_derivative', methods=['POST'])
def get_derivative():
    data = request.json
    x = symbols('x')
    try:
        # Parse the function
        f = sympify(data['funcion'])
        
        # Calculate the derivative
        f_prime = diff(f, x)
        
        # Convert to LaTeX for nice display
        original_latex = latex(f)
        derivative_latex = latex(f_prime)
        
        return jsonify({
            'original': str(f),
            'derivative': str(f_prime),
            'original_latex': original_latex,
            'derivative_latex': derivative_latex
        })
    except Exception as e:
        return jsonify({'error': str(e)}), 400

# Rutas para las páginas HTML
@app.route('/euler')
def euler():
    return render_template('euler.html')

@app.route('/runge_kutta')
def runge_kutta():
    return render_template('runge_kutta.html')

@app.route('/newton')
def newton():
    return render_template('newton.html')

if __name__ == '__main__':
    import os
    # Configuración para diferentes ambientes
    debug_mode = os.environ.get('FLASK_ENV', 'production') == 'development'
    host = os.environ.get('FLASK_HOST', '0.0.0.0')
    port = int(os.environ.get('FLASK_PORT', 5000))
    
    app.run(host=host, port=port, debug=debug_mode)