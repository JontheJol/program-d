#!/bin/bash
# Script para deploy en ambiente de pruebas

set -e  # Salir en caso de error

echo "🚀 Iniciando deployment a ambiente de PRUEBAS..."

# Variables
ENVIRONMENT="test"
IMAGE_TAG="test-$(date +%Y%m%d-%H%M%S)"
CONTAINER_NAME="metodos-numericos-test"
PORT=5001

# Construir imagen
echo "📦 Construyendo imagen Docker..."
docker build -t "metodos-numericos:${IMAGE_TAG}" .

# Parar contenedor existente si existe
echo "🛑 Parando contenedor existente..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Ejecutar nuevo contenedor
echo "▶️  Iniciando nuevo contenedor..."
docker run -d \
    --name $CONTAINER_NAME \
    --env-file config/.env.test \
    -p $PORT:5000 \
    --restart unless-stopped \
    "metodos-numericos:${IMAGE_TAG}"

# Verificar que el contenedor está ejecutándose
echo "🔍 Verificando estado del contenedor..."
sleep 5
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Deployment exitoso! Aplicación disponible en http://localhost:$PORT"
else
    echo "❌ Error en el deployment"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Health check
echo "🏥 Realizando health check..."
for i in {1..10}; do
    if curl -f http://localhost:$PORT/ > /dev/null 2>&1; then
        echo "✅ Health check exitoso!"
        break
    fi
    echo "⏳ Esperando que la aplicación esté lista... ($i/10)"
    sleep 3
done

echo "🎉 Deployment a ambiente de pruebas completado!"