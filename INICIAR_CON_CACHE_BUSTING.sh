#!/bin/bash

# Script para iniciar el proyecto PETCIMAGENES con cache busting

echo "🚀 Iniciando PETCIMAGENES Agent..."
echo ""

# Directorio del proyecto
PROJECT_DIR="/Users/hbva/AgentkitV1"
cd "$PROJECT_DIR"

# 1. Agregar timestamp al HTML para forzar recarga
echo "📝 Aplicando cache busting..."
TIMESTAMP=$(date +%s)
cd frontend
cp index.html "index_$TIMESTAMP.html"
cd ..

# Actualizar app.js para servir el nuevo archivo
sed -i.bak "s|'index.*\.html'|'index_$TIMESTAMP.html'|g" backend/src/app.js

echo "✅ Cache busting aplicado - Archivo: index_$TIMESTAMP.html"
echo ""

# 2. Iniciar el backend
echo "🔧 Iniciando backend en puerto 3000..."
cd backend
npm start &
BACKEND_PID=$!
echo "✅ Backend iniciado (PID: $BACKEND_PID)"
echo ""

# 3. Esperar a que el backend esté listo
echo "⏳ Esperando a que el backend esté listo..."
sleep 3

# 4. Iniciar ngrok
echo "🌐 Iniciando ngrok..."
ngrok http 3000 --log=stdout > ../ngrok.log 2>&1 &
NGROK_PID=$!
echo "✅ Ngrok iniciado (PID: $NGROK_PID)"
echo ""

# 5. Esperar a que ngrok esté listo
echo "⏳ Esperando URL de ngrok..."
sleep 3

# 6. Obtener URL de ngrok
NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"https://[^"]*' | grep -o 'https://.*' | head -1)

if [ -z "$NGROK_URL" ]; then
    echo "❌ Error: No se pudo obtener la URL de ngrok"
    echo "   Verifica que ngrok esté corriendo en http://localhost:4040"
    exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ PETCIMAGENES Agent está listo!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 URL Pública: $NGROK_URL"
echo "💻 Local: http://localhost:3000"
echo "📊 Ngrok Dashboard: http://localhost:4040"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  IMPORTANTE: Para evitar problemas de caché:"
echo "   1. Abre el navegador en INCÓGNITO"
echo "   2. Presiona Cmd+Shift+R para recargar"
echo "   3. O abre DevTools y marca 'Disable cache'"
echo ""
echo "📝 Para detener todo: Ctrl+C en esta terminal"
echo ""

# Esperar a que el usuario presione Ctrl+C
trap "echo ''; echo '🛑 Deteniendo servicios...'; kill $BACKEND_PID $NGROK_PID 2>/dev/null; echo '✅ Servicios detenidos'; exit 0" INT

# Mantener el script corriendo
wait
