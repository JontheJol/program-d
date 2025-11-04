import pytest
import sys
import os

# Agregar el directorio padre al path para importar app
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import app


@pytest.fixture
def client():
    """Fixture que proporciona un cliente de test para Flask"""
    app.config['TESTING'] = True
    app.config['WTF_CSRF_ENABLED'] = False
    
    with app.test_client() as client:
        with app.app_context():
            yield client


@pytest.fixture
def sample_function():
    """Función de ejemplo para testear métodos numéricos"""
    def f(x, y):
        return x + y
    return f


@pytest.fixture 
def sample_equation():
    """Ecuación de ejemplo para Newton-Raphson: x^2 - 4"""
    return "x**2 - 4"