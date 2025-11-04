import pytest
from app import euler_mejorado, runge_kutta_4, newton_raphson


class TestEulerMejorado:
    """Tests para el método de Euler Mejorado"""
    
    def test_euler_basico(self, sample_function):
        """Test básico del método de Euler"""
        f = sample_function
        pasos = euler_mejorado(f, x0=0, y0=1, h=0.1, xn=0.2)
        
        # Verificar que se generan los pasos correctos
        assert len(pasos) == 3  # 0.0, 0.1, 0.2
        assert pasos[0]['x'] == 0.0
        assert pasos[0]['y'] == 1.0
        assert pasos[1]['x'] == 0.1
        assert pasos[2]['x'] == 0.2
    
    def test_euler_valores_consistentes(self, sample_function):
        """Test de consistencia en los cálculos"""
        f = sample_function
        pasos = euler_mejorado(f, x0=0, y0=1, h=0.1, xn=0.1)
        
        step = pasos[0]
        # Verificar que k1 se calcula correctamente
        assert step['k1'] == f(step['x'], step['y'])
        
        # Verificar que y_pred se calcula correctamente
        expected_y_pred = step['y'] + 0.1 * step['k1']
        assert abs(step['y_pred'] - expected_y_pred) < 1e-10


class TestRungeKutta4:
    """Tests para el método de Runge-Kutta de 4to orden"""
    
    def test_rk4_basico(self, sample_function):
        """Test básico del método RK4"""
        f = sample_function
        pasos = runge_kutta_4(f, x0=0, y0=1, h=0.1, xn=0.2)
        
        # Verificar estructura de salida
        assert len(pasos) == 3
        assert all('k1' in paso for paso in pasos)
        assert all('k2' in paso for paso in pasos)
        assert all('k3' in paso for paso in pasos)
        assert all('k4' in paso for paso in pasos)
    
    def test_rk4_precision_mayor_que_euler(self):
        """Test que verifica que RK4 es más preciso que Euler"""
        def f_exacta(x, y):
            return 2*x  # dy/dx = 2x, solución exacta: y = x^2 + C
        
        # Mismo problema con ambos métodos
        euler_pasos = euler_mejorado(f_exacta, 0, 0, 0.1, 0.5)
        rk4_pasos = runge_kutta_4(f_exacta, 0, 0, 0.1, 0.5)
        
        # La solución exacta en x=0.5 es y = (0.5)^2 = 0.25
        euler_final = euler_pasos[-1]['y']
        rk4_final = rk4_pasos[-1]['y']
        
        # RK4 debería estar más cerca de la solución exacta
        assert abs(rk4_final - 0.25) < abs(euler_final - 0.25)


class TestNewtonRaphson:
    """Tests para el método de Newton-Raphson"""
    
    def test_newton_raiz_cuadrada(self):
        """Test encontrando la raíz cuadrada de 4"""
        ecuacion = "x**2 - 4"
        pasos = newton_raphson(ecuacion, x0=3.0, tolerancia=1e-6, max_iter=100)
        
        # Debería converger a x = 2 (raíz de x^2 - 4 = 0)
        assert len(pasos) > 0
        ultimo_paso = pasos[-1]
        assert abs(ultimo_paso['x_nuevo'] - 2.0) < 1e-6
    
    def test_newton_no_convergencia(self):
        """Test para verificar manejo de no convergencia"""
        ecuacion = "1"  # Ecuación sin raíz
        pasos = newton_raphson(ecuacion, x0=1.0, tolerancia=1e-6, max_iter=5)
        
        # Debería parar por máximo de iteraciones
        assert len(pasos) <= 5
    
    def test_newton_convergencia_rapida(self):
        """Test de convergencia rápida para función simple"""
        ecuacion = "x - 5"  # Raíz obvia en x = 5
        pasos = newton_raphson(ecuacion, x0=4.0, tolerancia=1e-10, max_iter=100)
        
        # Debería converger en pocas iteraciones
        assert len(pasos) < 10
        ultimo_paso = pasos[-1]
        assert abs(ultimo_paso['x_nuevo'] - 5.0) < 1e-10