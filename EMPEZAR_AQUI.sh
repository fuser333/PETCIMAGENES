#!/bin/bash

echo "🎯 CONFIGURACIÓN COMPLETA Y PRUEBA"
echo "===================================="
echo ""

# Verificar que los scripts existen
if [ ! -f "INICIAR_BACKEND.sh" ] || [ ! -f "INICIAR_NGROK.sh" ]; then
    echo "❌ Error: Scripts de inicio no encontrados"
    exit 1
fi

# Dar permisos de ejecución
chmod +x INICIAR_BACKEND.sh
chmod +x INICIAR_NGROK.sh

echo "✅ Scripts configurados correctamente"
echo ""
echo "📋 INSTRUCCIONES DE USO:"
echo ""
echo "1️⃣  TERMINAL 1 - Iniciar Backend:"
echo "   ./INICIAR_BACKEND.sh"
echo ""
echo "2️⃣  TERMINAL 2 - Iniciar ngrok:"
echo "   ./INICIAR_NGROK.sh"
echo "   📝 Copia la URL que te da (https://xxxx.ngrok-free.app)"
echo ""
echo "3️⃣  Actualizar frontend/app.js:"
echo "   Cambia la línea:"
echo "   const API_BASE_URL = 'http://localhost:3000';"
echo "   Por:"
echo "   const API_BASE_URL = 'https://TU-URL-DE-NGROK';"
echo ""
echo "4️⃣  Abrir el frontend:"
echo "   cd frontend && open index.html"
echo ""
echo "=========================================="
echo "¿Listo para empezar? Ejecuta:"
echo "./INICIAR_BACKEND.sh"
echo "=========================================="
