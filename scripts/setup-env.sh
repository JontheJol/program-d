#!/bin/bash
# Script para configurar archivos de ambiente desde templates

echo "🔧 Configurando archivos de ambiente..."

ENVIRONMENTS=("development" "test" "staging" "production")

for env in "${ENVIRONMENTS[@]}"; do
    template_file="config/.env.${env}.template"
    env_file="config/.env.${env}"
    
    if [ -f "$template_file" ]; then
        if [ ! -f "$env_file" ]; then
            echo "📋 Creando $env_file desde template..."
            cp "$template_file" "$env_file"
            echo "✅ $env_file creado"
        else
            echo "ℹ️  $env_file ya existe, omitiendo..."
        fi
    else
        echo "⚠️  Template $template_file no encontrado"
    fi
done

echo ""
echo "🎯 IMPORTANTE: Edita los archivos .env.* con tus valores reales"
echo "🔒 NUNCA subas los archivos .env.* reales a git"
echo ""
echo "Para generar una SECRET_KEY segura:"
echo "python -c \"import secrets; print(secrets.token_hex(32))\""