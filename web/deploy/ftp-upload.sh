#!/bin/bash

HOST="ftp.imagemia.com"
USER="imagemiadeploy"
PASS="zydGeb-jajrec-3fipgu"

echo "🚀 Conectando a FTP: $HOST"
echo "👤 Usuario: $USER"

lftp -c "
set ftp:ssl-allow no
open ftp://$USER:$PASS@$HOST
pwd
ls -la
lcd .
cd /public_html || cd /
ls -la
mirror -R --delete-first --verbose --parallel=3 ./ ./
bye
"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Archivos subidos exitosamente!"
    echo "🌐 Tu sitio está en: https://imagemia.com"
else
    echo "❌ Error al subir archivos"
fi
