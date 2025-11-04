# Makefile para automatizar tareas comunes del proyecto

.PHONY: help install test lint format build run clean docker-build docker-run deploy-test deploy-staging deploy-prod

# Variables
PYTHON=python
PIP=pip
PYTEST=pytest
BLACK=black
FLAKE8=flake8
DOCKER=docker
DOCKER_COMPOSE=docker-compose

help: ## Mostrar ayuda disponible
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Instalar dependencias
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

install-dev: ## Instalar dependencias de desarrollo
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	$(PIP) install pytest pytest-cov pytest-flask black flake8 coverage

test: ## Ejecutar tests
	$(PYTEST) tests/ -v

test-coverage: ## Ejecutar tests con reporte de cobertura
	$(PYTEST) tests/ -v --cov=app --cov-report=html --cov-report=term-missing

lint: ## Analizar código con flake8
	$(FLAKE8) . --count --select=E9,F63,F7,F82 --show-source --statistics
	$(FLAKE8) . --count --max-complexity=10 --max-line-length=88 --statistics

format: ## Formatear código con black
	$(BLACK) .

format-check: ## Verificar formato sin cambios
	$(BLACK) --check --diff .

run: ## Ejecutar aplicación en modo desarrollo
	$(PYTHON) app.py

build: ## Construir imagen Docker
	$(DOCKER) build -t metodos-numericos:latest .

docker-run: ## Ejecutar con Docker
	$(DOCKER) run -p 5000:5000 --env-file config/.env.development metodos-numericos:latest

docker-dev: ## Ejecutar entorno completo de desarrollo
	$(DOCKER_COMPOSE) up

docker-test: ## Ejecutar en modo test
	$(DOCKER_COMPOSE) --profile test up app-test

docker-staging: ## Ejecutar en modo staging
	$(DOCKER_COMPOSE) --profile staging up app-staging

docker-prod: ## Ejecutar en modo producción
	$(DOCKER_COMPOSE) --profile production up app-production

deploy-test: ## Deploy a ambiente de pruebas
	./scripts/deploy-test.sh

deploy-staging: ## Deploy a preproducción
	./scripts/deploy-staging.sh

deploy-prod: ## Deploy a producción (requiere confirmación)
	./scripts/deploy-production.sh

clean: ## Limpiar archivos temporales y caché
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type f -name ".coverage" -delete
	find . -type d -name "htmlcov" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +

docker-clean: ## Limpiar imágenes Docker no utilizadas
	$(DOCKER) system prune -a --volumes

logs-test: ## Ver logs del ambiente de pruebas
	$(DOCKER) logs -f metodos-numericos-test

logs-staging: ## Ver logs de preproducción
	$(DOCKER) logs -f metodos-numericos-staging

logs-prod: ## Ver logs de producción
	$(DOCKER) logs -f metodos-numericos-production

health-check: ## Verificar estado de todos los ambientes
	@echo "🔍 Verificando ambientes..."
	@echo "Test (Puerto 5001):"
	@curl -f http://localhost:5001/ > /dev/null 2>&1 && echo "✅ Test OK" || echo "❌ Test DOWN"
	@echo "Staging (Puerto 5002):"
	@curl -f http://localhost:5002/ > /dev/null 2>&1 && echo "✅ Staging OK" || echo "❌ Staging DOWN"
	@echo "Production (Puerto 5003):"
	@curl -f http://localhost:5003/ > /dev/null 2>&1 && echo "✅ Production OK" || echo "❌ Production DOWN"

setup-env: ## Configurar archivos de ambiente desde templates
	./scripts/setup-env.sh

setup: ## Configuración inicial del proyecto
	@echo "🚀 Configurando proyecto..."
	make install-dev
	make setup-env
	@echo "🧪 Ejecutando tests iniciales..."
	make test
	@echo "✅ Proyecto configurado correctamente!"
	@echo ""
	@echo "Comandos útiles:"
	@echo "  make run          - Ejecutar aplicación"
	@echo "  make docker-dev   - Ejecutar con Docker"
	@echo "  make test         - Ejecutar tests"
	@echo "  make help         - Ver todos los comandos"