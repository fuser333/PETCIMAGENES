#!/bin/bash

HOST="ftp.imagemia.com"
USER="imagemiadeploy@imagemia.com"
PASS="zydGeb-jajrec-3fipgu"

echo "🚀 Moviendo archivos a public_html..."

lftp -c "
set ftp:ssl-allow no
open ftp://$USER:$PASS@$HOST

echo '📍 Directorio actual:'
pwd

echo '📂 Listando contenido:'
ls -la

echo '⬆️  Subiendo archivos a ../public_html'
cd ../public_html
pwd
ls -la

lcd .
mirror -R --delete-first --verbose --parallel=2 ./ ./

echo '✅ Archivos en public_html:'
ls -la

bye
"

echo ""
echo "✅ ¡Listo! Verifica: https://imagemia.com"
