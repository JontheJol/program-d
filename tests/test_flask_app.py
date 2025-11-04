import pytest
import json
from app import app


class TestFlaskRoutes:
    """Tests para las rutas de la aplicación Flask"""
    
    def test_home_page(self, client):
        """Test de la página principal"""
        response = client.get('/')
        assert response.status_code == 200
        assert b'M\xc3\xa9todos Num\xc3\xa9ricos' in response.data or b'Metodos Numericos' in response.data
    
    def test_euler_page(self, client):
        """Test de la página de Euler"""
        response = client.get('/euler')
        assert response.status_code == 200
    
    def test_runge_kutta_page(self, client):
        """Test de la página de Runge-Kutta"""
        response = client.get('/runge_kutta')
        assert response.status_code == 200
    
    def test_newton_page(self, client):
        """Test de la página de Newton"""
        response = client.get('/newton')
        assert response.status_code == 200


class TestAPIEndpoints:
    """Tests para los endpoints de la API"""
    
    def test_euler_api_valid_input(self, client):
        """Test del endpoint de Euler con entrada válida"""
        data = {
            'ecuacion': 'x + y',
            'x0': 0,
            'y0': 1,
            'h': 0.1,
            'xn': 0.2
        }
        response = client.post('/calcular_euler', 
                             data=json.dumps(data),
                             content_type='application/json')
        
        assert response.status_code == 200
        result = json.loads(response.data)
        assert 'pasos' in result
        assert len(result['pasos']) > 0
    
    def test_runge_kutta_api_valid_input(self, client):
        """Test del endpoint de Runge-Kutta con entrada válida"""
        data = {
            'ecuacion': 'x + y',
            'x0': 0,
            'y0': 1,
            'h': 0.1,
            'xn': 0.2
        }
        response = client.post('/calcular_runge_kutta',
                             data=json.dumps(data),
                             content_type='application/json')
        
        assert response.status_code == 200
        result = json.loads(response.data)
        assert 'pasos' in result
        assert len(result['pasos']) > 0
    
    def test_newton_api_valid_input(self, client):
        """Test del endpoint de Newton con entrada válida"""
        data = {
            'ecuacion': 'x**2 - 4',
            'x0': 3,
            'tolerancia': 0.000001,
            'max_iter': 100
        }
        response = client.post('/calcular_newton',
                             data=json.dumps(data),
                             content_type='application/json')
        
        assert response.status_code == 200
        result = json.loads(response.data)
        assert 'pasos' in result
        assert len(result['pasos']) > 0
    
    def test_api_invalid_json(self, client):
        """Test de manejo de JSON inválido"""
        response = client.post('/calcular_euler',
                             data='invalid json',
                             content_type='application/json')
        
        # Debería manejar el error graciosamente
        assert response.status_code in [400, 500]
    
    def test_missing_parameters(self, client):
        """Test de parámetros faltantes"""
        data = {
            'ecuacion': 'x + y'
            # Faltan x0, y0, h, xn
        }
        response = client.post('/calcular_euler',
                             data=json.dumps(data),
                             content_type='application/json')
        
        # Debería retornar error por parámetros faltantes
        assert response.status_code in [400, 500]


class TestApplicationHealth:
    """Tests de salud de la aplicación"""
    
    def test_app_exists(self):
        """Test que la aplicación existe"""
        assert app is not None
    
    def test_app_in_testing_mode(self, client):
        """Test que la app está en modo testing"""
        assert app.config['TESTING']