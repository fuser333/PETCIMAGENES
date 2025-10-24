#!/bin/bash

echo "🔧 INSTALACIÓN Y CONFIGURACIÓN AUTOMÁTICA"
echo "=========================================="
echo ""

cd /Users/hbva/AgentkitV1/backend

# Verificar si existe node_modules
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias del backend..."
    npm install
    
    if [ $? -ne 0 ]; then
        echo "❌ Error al instalar dependencias"
        exit 1
    fi
    echo "✅ Dependencias instaladas correctamente"
else
    echo "✅ Dependencias ya instaladas"
fi

echo ""
echo "🚀 Iniciando servidor backend..."
echo "Servidor corriendo en: http://localhost:3000"
echo ""
echo "⚠️  Mantén esta terminal abierta"
echo "⚠️  Presiona Ctrl+C para detener el servidor"
echo ""

# Usar npm start en lugar de npm run dev para evitar el problema con nodemon
npm start
