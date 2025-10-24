#!/bin/bash

echo "🚀 INICIANDO SOLO BACKEND + ABRIR NAVEGADOR"
echo "==========================================="
echo ""

cd /Users/hbva/AgentkitV1/backend

# Verificar dependencias
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
fi

# Crear logs
mkdir -p ../logs

# Iniciar backend
echo "🔄 Iniciando backend..."
npm start > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../logs/backend.pid

sleep 3

if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo "❌ Error al iniciar backend"
    cat ../logs/backend.log
    exit 1
fi

echo "✅ Backend corriendo en http://localhost:3000 (PID: $BACKEND_PID)"
echo ""

# Actualizar frontend a localhost
cd ../frontend
if grep -q "https://rosia-unbrocaded" app.js 2>/dev/null; then
    echo "📝 Actualizando URL del frontend..."
    sed -i '' 's|https://rosia-unbrocaded-distinguishedly.ngrok-free.dev|http://localhost:3000|g' app.js 2>/dev/null || \
    sed -i 's|https://rosia-unbrocaded-distinguishedly.ngrok-free.dev|http://localhost:3000|g' app.js 2>/dev/null
    echo "✅ URL actualizada a localhost:3000"
fi

echo ""
echo "=========================================="
echo "✅ ¡BACKEND LISTO!"
echo "=========================================="
echo ""
echo "🌐 Abriendo navegador..."

# Abrir el HTML directamente
open index.html 2>/dev/null || xdg-open index.html 2>/dev/null

echo ""
echo "⚠️  IMPORTANTE:"
echo "   Si ves errores CORS, es porque Safari/Chrome"
echo "   bloquea peticiones desde file:///"
echo ""
echo "   SOLUCIÓN: Usa Firefox o ejecuta:"
echo "   ./INICIAR_NODE.sh"
echo ""
echo "📊 Ver logs del backend:"
echo "   tail -f logs/backend.log"
echo ""
echo "🛑 Para detener backend:"
echo "   kill $BACKEND_PID"
echo ""

# Mostrar logs
tail -f ../logs/backend.log

# Cleanup
trap "kill $BACKEND_PID 2>/dev/null; echo 'Backend detenido'" EXIT
