#!/bin/bash

# Script para iniciar el backend desde la ruta correcta

echo "🚀 Iniciando PETCIMAGENES Backend..."
echo ""

# Ir al directorio del backend
cd /Users/hbva/AgentkitV1/backend

# Verificar que existe .env
if [ ! -f ".env" ]; then
    echo "❌ Error: Archivo .env no encontrado"
    exit 1
fi

# Verificar que existe node_modules
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
fi

# Limpiar puerto 3000
echo "🧹 Limpiando puerto 3000..."
lsof -ti:3000 | xargs kill -9 2>/dev/null
sleep 1

# Crear directorio de logs si no existe
mkdir -p ../logs

# Iniciar el servidor
echo "✅ Iniciando servidor en puerto 3000..."
npm start

