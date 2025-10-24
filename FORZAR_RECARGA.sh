#!/bin/bash

echo "🔄 FORZANDO RECARGA DEL FRONTEND..."
echo ""

cd /Users/hbva/AgentkitV1/frontend

# Agregar timestamp al final del HTML para forzar recarga
TIMESTAMP=$(date +%s)
echo "<!-- Cache Buster: $TIMESTAMP -->" >> index.html

echo "✅ Cache buster agregado: $TIMESTAMP"
echo ""
echo "🌐 Ahora abre en el navegador:"
echo "   https://rosia-unbrocaded-distinguishedly.ngrok-free.dev"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   1. Cierra TODAS las pestañas de la app"
echo "   2. Abre NUEVA ventana incógnito (Cmd + Shift + N)"
echo "   3. Pega la URL y presiona Enter"
echo "   4. Deberías ver el botón verde 'Subir Archivos'"
echo ""
