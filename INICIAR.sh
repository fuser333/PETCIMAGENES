#!/bin/bash

echo "🚀 INICIANDO PETCIMAGENES - TODO EN UNO"
echo "======================================"
echo ""

cd /Users/hbva/AgentkitV1/backend

# Verificar e instalar dependencias
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias..."
    npm install
    echo ""
fi

# Crear carpeta logs
mkdir -p ../logs

# Matar cualquier proceso previo en el puerto 3000
echo "🧹 Limpiando puertos..."
lsof -ti:3000 | xargs kill -9 2>/dev/null
sleep 1

# Iniciar servidor (backend + frontend en puerto 3000)
echo "🚀 Iniciando servidor en puerto 3000..."
echo ""
npm start > ../logs/server.log 2>&1 &
SERVER_PID=$!
echo $SERVER_PID > ../logs/server.pid

# Esperar a que inicie
sleep 4

# Verificar que esté corriendo
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo "❌ Error al iniciar servidor"
    echo ""
    echo "Ver logs:"
    cat ../logs/server.log
    exit 1
fi

echo "✅ Servidor corriendo (PID: $SERVER_PID)"
echo ""
echo "=========================================="
echo "✅ ¡TODO LISTO!"
echo "=========================================="
echo ""
echo "🌐 Abre tu navegador en:"
echo "   http://localhost:3000"
echo ""
echo "📊 Características:"
echo "   ✅ Backend + Frontend en un solo puerto"
echo "   ✅ Upload de archivos con botón 📎"
echo "   ✅ Agent con 3 herramientas"
echo "   ✅ Streaming en tiempo real"
echo ""
echo "📝 Ver logs:"
echo "   tail -f logs/server.log"
echo ""
echo "🛑 Para detener:"
echo "   kill $SERVER_PID"
echo "   o presiona Ctrl+C"
echo ""
echo "=========================================="
echo ""

# Abrir navegador
sleep 1
open http://localhost:3000 2>/dev/null

# Mostrar logs
echo "📊 Logs del servidor (Ctrl+C para salir):"
echo "------------------------------------------"
tail -f ../logs/server.log

# Cleanup
trap "kill $SERVER_PID 2>/dev/null; echo; echo '✅ Servidor detenido'" EXIT
