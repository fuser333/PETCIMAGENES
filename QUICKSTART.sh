#!/bin/bash

# ⚡ QUICK START - PETCIMAGENES AI
# Ejecuta este script para iniciar todo automáticamente

echo "⚡ QUICK START - PETCIMAGENES AI"
echo "=================================="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "INICIAR_NGROK.sh" ]; then
    echo "❌ Error: Ejecuta este script desde /Users/hbva/AgentkitV1"
    exit 1
fi

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado"
    echo "   Instala desde: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js detectado: $(node --version)"

# Verificar npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm no está instalado"
    exit 1
fi

echo "✅ npm detectado: $(npm --version)"

# Verificar ngrok
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok no está instalado"
    echo "   Instala con: brew install ngrok"
    exit 1
fi

echo "✅ ngrok detectado: $(ngrok version)"
echo ""

# Verificar dependencias del backend
echo "🔍 Verificando dependencias..."
cd backend

if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
fi

echo "✅ Dependencias OK"
echo ""

# Verificar .env
if [ ! -f ".env" ]; then
    echo "❌ Archivo .env no encontrado"
    echo "   Crea uno basado en .env.example"
    exit 1
fi

# Verificar variables críticas
if ! grep -q "OPENAI_API_KEY" .env; then
    echo "❌ OPENAI_API_KEY no configurado en .env"
    exit 1
fi

if ! grep -q "VECTOR_STORE_ID" .env; then
    echo "❌ VECTOR_STORE_ID no configurado en .env"
    exit 1
fi

echo "✅ Variables de entorno OK"
echo ""

cd ..

# Todo listo, iniciar
echo "🚀 Iniciando PETCIMAGENES AI..."
echo ""
./INICIAR_NGROK.sh
