#!/bin/bash

HOST="ftp.4cf7eca6-71a4-42d6-9df4-40d3c220da44-internalonly.spacecharged.site"
USER="imagemiadeploy@imagemia.com"
PASS="zydGeb-jajrec-3fipgu"

echo "🚀 Conectando al servidor FTP correcto de Spaceship..."
echo "📡 Host: $HOST"
echo "👤 Usuario: $USER"

lftp -c "
set ftp:ssl-allow no
set net:timeout 30
open ftp://$USER:$PASS@$HOST

echo '📍 Directorio actual al conectar:'
pwd

echo '📂 Listando estructura:'
ls -la

echo '🔍 Buscando public_html...'
cd ../public_html 2>/dev/null || cd ../../public_html 2>/dev/null || cd /home/fwrikwglvd/public_html 2>/dev/null || cd public_html 2>/dev/null

pwd
ls -la

echo '📤 Subiendo archivos...'
lcd .
mirror -R --delete-first --verbose --parallel=2 ./ ./

echo '✅ Contenido final de public_html:'
ls -la

bye
"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Archivos subidos exitosamente!"
    echo "🌐 Verifica: https://imagemia.com"
else
    echo "❌ Error - puede que necesitemos crear nueva cuenta apuntando a public_html"
fi
