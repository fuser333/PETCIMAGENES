#!/bin/bash

echo "🚀 INSTALACIÓN Y PRUEBA AUTOMÁTICA COMPLETA"
echo "============================================"
echo ""

cd /Users/hbva/AgentkitV1

# Paso 1: Instalar dependencias del backend
echo "📦 Paso 1/4: Instalando dependencias del backend..."
cd backend
npm install --silent

if [ $? -ne 0 ]; then
    echo "❌ Error al instalar dependencias"
    exit 1
fi

echo "✅ Dependencias instaladas"
echo ""

# Paso 2: Iniciar el backend en segundo plano
echo "🚀 Paso 2/4: Iniciando servidor backend..."
npm start > ../backend.log 2>&1 &
BACKEND_PID=$!

echo "✅ Backend iniciado (PID: $BACKEND_PID)"
echo "📝 Logs en: backend.log"
echo ""

# Esperar a que el backend esté listo
echo "⏳ Esperando que el backend esté listo..."
sleep 3

# Verificar que el backend esté corriendo
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo "❌ Error: El backend no se inició correctamente"
    echo "Ver logs en backend.log"
    exit 1
fi

echo "✅ Backend corriendo en http://localhost:3000"
echo ""

# Paso 3: Iniciar ngrok en segundo plano
echo "🌐 Paso 3/4: Iniciando ngrok..."

if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok no está instalado"
    echo "Instálalo con: brew install ngrok/ngrok/ngrok"
    kill $BACKEND_PID
    exit 1
fi

ngrok http 3000 > ../ngrok.log 2>&1 &
NGROK_PID=$!

echo "✅ ngrok iniciado (PID: $NGROK_PID)"
echo ""

# Esperar a que ngrok esté listo y obtener la URL
echo "⏳ Esperando URL de ngrok..."
sleep 5

# Obtener la URL de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | grep -o 'https://[^"]*' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ No se pudo obtener la URL de ngrok"
    echo "Ver logs en ngrok.log"
    kill $BACKEND_PID $NGROK_PID
    exit 1
fi

echo "✅ URL de ngrok obtenida: $NGROK_URL"
echo ""

# Paso 4: Actualizar el frontend automáticamente
echo "📝 Paso 4/4: Actualizando frontend con URL de ngrok..."
cd ../frontend

# Hacer backup del app.js original
cp app.js app.js.backup

# Reemplazar la URL en app.js
sed -i '' "s|const API_BASE_URL = 'http://localhost:3000';|const API_BASE_URL = '$NGROK_URL';|g" app.js

if [ $? -eq 0 ]; then
    echo "✅ Frontend actualizado correctamente"
else
    echo "⚠️  No se pudo actualizar automáticamente"
    echo "Edita manualmente frontend/app.js y cambia la URL a: $NGROK_URL"
fi

echo ""
echo "============================================"
echo "✅ ¡TODO LISTO!"
echo "============================================"
echo ""
echo "📊 ESTADO DEL SISTEMA:"
echo "   Backend PID: $BACKEND_PID"
echo "   ngrok PID: $NGROK_PID"
echo "   URL Pública: $NGROK_URL"
echo ""
echo "🌐 ABRIR CHAT:"
echo "   open /Users/hbva/AgentkitV1/frontend/index.html"
echo ""
echo "📝 LOGS:"
echo "   Backend: tail -f /Users/hbva/AgentkitV1/backend.log"
echo "   ngrok: tail -f /Users/hbva/AgentkitV1/ngrok.log"
echo ""
echo "🛑 PARA DETENER TODO:"
echo "   kill $BACKEND_PID $NGROK_PID"
echo ""
echo "🎯 PRUEBA EL CHAT:"
echo "   Pregunta: '¿Cuál es tu función?'"
echo "============================================"

# Abrir el frontend automáticamente
open /Users/hbva/AgentkitV1/frontend/index.html

echo ""
echo "✨ Frontend abierto en el navegador"
echo ""
echo "⚠️  Presiona Ctrl+C para detener todo"
echo ""

# Mantener el script corriendo y mostrar logs
tail -f ../backend.log
