#!/bin/bash

echo "🚀 INICIANDO CON NGROK"
echo "====================="
echo ""

cd /Users/hbva/AgentkitV1/backend

# Verificar ngrok
if ! command -v ngrok &> /dev/null; then
    echo "❌ ngrok no está instalado"
    echo ""
    echo "Instálalo con: brew install ngrok"
    exit 1
fi

# Limpiar puertos
echo "🧹 Limpiando puertos..."
lsof -ti:3000 | xargs kill -9 2>/dev/null
sleep 1

# Crear logs
mkdir -p ../logs

# Iniciar backend
echo "🚀 Iniciando backend en puerto 3000..."
npm start > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../logs/backend.pid

sleep 3

if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo "❌ Error al iniciar backend"
    cat ../logs/backend.log
    exit 1
fi

echo "✅ Backend corriendo (PID: $BACKEND_PID)"
echo ""

# Iniciar ngrok
echo "🌐 Iniciando ngrok..."
ngrok http 3000 > ../logs/ngrok.log 2>&1 &
NGROK_PID=$!
echo $NGROK_PID > ../logs/ngrok.pid

sleep 3

# Obtener URL de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | grep -o 'https://[^"]*' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ No se pudo obtener URL de ngrok"
    kill $BACKEND_PID $NGROK_PID 2>/dev/null
    exit 1
fi

echo "✅ Ngrok corriendo (PID: $NGROK_PID)"
echo ""
echo "=========================================="
echo "✅ ¡TODO LISTO!"
echo "=========================================="
echo ""
echo "🌐 TU URL PÚBLICA:"
echo "   $NGROK_URL"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   1. Ve a: https://platform.openai.com/settings/organization/domains"
echo "   2. Agrega este dominio: ${NGROK_URL#https://}"
echo "   3. Luego abre: $NGROK_URL"
echo ""
echo "📊 PIDs:"
echo "   Backend: $BACKEND_PID"
echo "   Ngrok:   $NGROK_PID"
echo ""
echo "🛑 Para detener:"
echo "   kill $BACKEND_PID $NGROK_PID"
echo ""
echo "=========================================="
echo ""

# Mostrar logs
tail -f ../logs/backend.log

# Cleanup
trap "kill $BACKEND_PID $NGROK_PID 2>/dev/null; echo; echo '✅ Servicios detenidos'" EXIT
