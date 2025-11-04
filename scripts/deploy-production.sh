#!/bin/bash
# Script para deploy en ambiente de producción

set -e  # Salir en caso de error

echo "🚀 Iniciando deployment a PRODUCCIÓN..."
echo "⚠️  ADVERTENCIA: Este es un deployment a PRODUCCIÓN"
echo "💡 Presiona CTRL+C en los próximos 10 segundos para cancelar..."
sleep 10

# Variables
ENVIRONMENT="production"
IMAGE_TAG="v$(date +%Y%m%d-%H%M%S)"
CONTAINER_NAME="metodos-numericos-production"
PORT=5003

# Validaciones estrictas pre-deployment
echo "🔍 Ejecutando validaciones críticas..."

# Verificar que estamos en la rama main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "❌ Error: Deployment a producción solo desde rama 'main'"
    echo "   Rama actual: $CURRENT_BRANCH"
    exit 1
fi

# Verificar que no hay cambios sin commit
if ! git diff --quiet; then
    echo "❌ Error: Hay cambios sin commit. Commit todos los cambios antes del deployment"
    exit 1
fi

# Verificar configuración de producción
if [ ! -f "config/.env.production" ]; then
    echo "❌ Archivo de configuración de producción no encontrado"
    exit 1
fi

# Ejecutar todos los tests
echo "🧪 Ejecutando suite completa de tests..."
python -m pytest tests/ -v --tb=short --cov=app --cov-report=term-missing
if [ $? -ne 0 ]; then
    echo "❌ Tests fallaron. Cancelando deployment"
    exit 1
fi

# Verificar que la aplicación puede construirse
echo "📦 Verificando build de la aplicación..."
docker build -t "metodos-numericos:${IMAGE_TAG}" .

# Crear tag de git para el release
echo "🏷️  Creando tag de release..."
git tag -a "release-${IMAGE_TAG}" -m "Release ${IMAGE_TAG} - $(date)"

# Blue-Green deployment simulation
CONTAINER_NAME_NEW="${CONTAINER_NAME}-new"
CONTAINER_NAME_OLD="${CONTAINER_NAME}-old"

# Iniciar nueva versión en puerto temporal
echo "▶️  Iniciando nueva versión..."
docker run -d \
    --name $CONTAINER_NAME_NEW \
    --env-file config/.env.production \
    -p 5999:5000 \
    --restart unless-stopped \
    --memory="1g" \
    --cpus="2.0" \
    "metodos-numericos:${IMAGE_TAG}"

# Health check de la nueva versión
echo "🏥 Verificando nueva versión..."
sleep 15
HEALTH_OK=false
for i in {1..20}; do
    if curl -f http://localhost:5999/ > /dev/null 2>&1; then
        echo "✅ Nueva versión responde correctamente"
        HEALTH_OK=true
        break
    fi
    echo "⏳ Esperando que la nueva versión esté lista... ($i/20)"
    sleep 5
done

if [ "$HEALTH_OK" != "true" ]; then
    echo "❌ Nueva versión falló health check"
    docker logs $CONTAINER_NAME_NEW
    docker stop $CONTAINER_NAME_NEW
    docker rm $CONTAINER_NAME_NEW
    exit 1
fi

# Test de endpoints críticos en nueva versión
echo "🔬 Probando endpoints críticos en nueva versión..."
curl -f http://localhost:5999/euler > /dev/null || { echo "❌ Endpoint /euler falla"; exit 1; }
curl -f http://localhost:5999/newton > /dev/null || { echo "❌ Endpoint /newton falla"; exit 1; }
curl -f http://localhost:5999/runge_kutta > /dev/null || { echo "❌ Endpoint /runge_kutta falla"; exit 1; }

# Hacer el switch (Blue-Green deployment)
echo "🔄 Realizando switch de producción..."

# Renombrar contenedor actual como old (si existe)
if docker ps | grep -q "^.*$CONTAINER_NAME[^-]"; then
    echo "📦 Moviendo versión actual a backup..."
    docker stop $CONTAINER_NAME || true
    docker rename $CONTAINER_NAME $CONTAINER_NAME_OLD 2>/dev/null || true
fi

# Parar nueva versión temporalmente
docker stop $CONTAINER_NAME_NEW

# Renombrar y reiniciar en puerto de producción
docker rename $CONTAINER_NAME_NEW $CONTAINER_NAME
docker run -d \
    --name "${CONTAINER_NAME}-final" \
    --env-file config/.env.production \
    -p $PORT:5000 \
    --restart unless-stopped \
    --memory="1g" \
    --cpus="2.0" \
    "metodos-numericos:${IMAGE_TAG}"

# Remover el contenedor temporal
docker rm $CONTAINER_NAME

# Renombrar el contenedor final
docker rename "${CONTAINER_NAME}-final" $CONTAINER_NAME

# Verificación final
echo "🔍 Verificación final de producción..."
sleep 10
if docker ps | grep -q $CONTAINER_NAME; then
    echo "✅ Deployment exitoso en producción!"
else
    echo "❌ Error crítico en deployment de producción"
    # Rollback automático
    if docker ps -a | grep -q $CONTAINER_NAME_OLD; then
        echo "🔙 Iniciando rollback automático..."
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        docker rename $CONTAINER_NAME_OLD $CONTAINER_NAME
        docker start $CONTAINER_NAME
        echo "✅ Rollback completado"
    fi
    exit 1
fi

# Limpiar versión antigua después de éxito
if docker ps -a | grep -q $CONTAINER_NAME_OLD; then
    echo "🧹 Limpiando versión anterior..."
    docker stop $CONTAINER_NAME_OLD 2>/dev/null || true
    docker rm $CONTAINER_NAME_OLD 2>/dev/null || true
fi

# Push del tag a repositorio
echo "📤 Subiendo tag al repositorio..."
git push origin "release-${IMAGE_TAG}"

# Limpiar imágenes antiguas (mantener solo las 5 más recientes)
echo "🧹 Limpiando imágenes antiguas..."
docker images "metodos-numericos" --format "table {{.Repository}}:{{.Tag}} {{.CreatedAt}}" | \
    grep -v "REPOSITORY" | sort -k2 -r | tail -n +6 | awk '{print $1}' | \
    xargs -r docker rmi || true

echo ""
echo "🎉🎉🎉 DEPLOYMENT A PRODUCCIÓN COMPLETADO EXITOSAMENTE! 🎉🎉🎉"
echo "📊 URL de producción: http://localhost:$PORT"
echo "🏷️  Versión desplegada: ${IMAGE_TAG}"
echo "📋 Para ver logs: docker logs -f $CONTAINER_NAME"
echo "📈 Para monitorear: docker stats $CONTAINER_NAME"