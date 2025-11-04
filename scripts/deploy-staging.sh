#!/bin/bash
# Script para deploy en ambiente de preproducción

set -e  # Salir en caso de error

echo "🚀 Iniciando deployment a ambiente de PREPRODUCCIÓN..."

# Variables
ENVIRONMENT="staging"
IMAGE_TAG="staging-$(date +%Y%m%d-%H%M%S)"
CONTAINER_NAME="metodos-numericos-staging"
PORT=5002

# Validaciones pre-deployment
echo "🔍 Ejecutando validaciones pre-deployment..."

# Verificar que los tests pasan
echo "🧪 Ejecutando tests..."
python -m pytest tests/ -v --tb=short

# Verificar configuración
if [ ! -f "config/.env.staging" ]; then
    echo "❌ Archivo de configuración de staging no encontrado"
    exit 1
fi

# Construir imagen
echo "📦 Construyendo imagen Docker..."
docker build -t "metodos-numericos:${IMAGE_TAG}" .

# Crear backup del contenedor actual (si existe)
if docker ps -a | grep -q $CONTAINER_NAME; then
    echo "💾 Creando backup del contenedor actual..."
    BACKUP_NAME="${CONTAINER_NAME}-backup-$(date +%Y%m%d-%H%M%S)"
    docker commit $CONTAINER_NAME "metodos-numericos:$BACKUP_NAME" || true
fi

# Parar contenedor existente
echo "🛑 Parando contenedor existente..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Ejecutar nuevo contenedor
echo "▶️  Iniciando nuevo contenedor..."
docker run -d \
    --name $CONTAINER_NAME \
    --env-file config/.env.staging \
    -p $PORT:5000 \
    --restart unless-stopped \
    --memory="512m" \
    --cpus="1.0" \
    "metodos-numericos:${IMAGE_TAG}"

# Verificar deployment
echo "🔍 Verificando estado del contenedor..."
sleep 10
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Contenedor iniciado correctamente"
else
    echo "❌ Error en el deployment"
    docker logs $CONTAINER_NAME
    exit 1
fi

# Health check extendido
echo "🏥 Realizando health checks..."
for i in {1..15}; do
    if curl -f http://localhost:$PORT/ > /dev/null 2>&1; then
        echo "✅ Health check básico exitoso!"
        break
    fi
    echo "⏳ Esperando que la aplicación esté lista... ($i/15)"
    sleep 5
done

# Test de endpoints críticos
echo "🔬 Probando endpoints críticos..."
curl -f http://localhost:$PORT/euler > /dev/null || echo "⚠️  Advertencia: endpoint /euler no responde"
curl -f http://localhost:$PORT/newton > /dev/null || echo "⚠️  Advertencia: endpoint /newton no responde"
curl -f http://localhost:$PORT/runge_kutta > /dev/null || echo "⚠️  Advertencia: endpoint /runge_kutta no responde"

# Limpiar imágenes antiguas (mantener solo las 3 más recientes)
echo "🧹 Limpiando imágenes antiguas..."
docker images "metodos-numericos" --format "table {{.Repository}}:{{.Tag}} {{.CreatedAt}}" | \
    grep -v "REPOSITORY" | sort -k2 -r | tail -n +4 | awk '{print $1}' | \
    xargs -r docker rmi || true

echo "🎉 Deployment a preproducción completado!"
echo "📊 URL: http://localhost:$PORT"
echo "📋 Para ver logs: docker logs -f $CONTAINER_NAME"