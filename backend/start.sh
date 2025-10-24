#!/bin/bash

echo "🚀 Iniciando PETCIMAGENES Agent System"
echo "======================================"
echo ""

# Verificar que existe el .env
if [ ! -f ".env" ]; then
    echo "❌ Error: Archivo .env no encontrado"
    exit 1
fi

echo "✅ Archivo .env encontrado"
echo "✅ Workflow ID: wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8"
echo ""

# Verificar node_modules
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
fi

echo "🔄 Iniciando servidor en modo desarrollo..."
echo ""
npm run dev
