#!/bin/bash

HOST="ftp.imagemia.com"
USER="imagemiadeploy@imagemia.com"
PASS="zydGeb-jajrec-3fipgu"

echo "🚀 Conectando a FTP: $HOST"
echo "👤 Usuario: $USER"

lftp -c "
set ftp:ssl-allow no
set net:timeout 30
set net:max-retries 3
open ftp://$USER:$PASS@$HOST
echo 'Conectado exitosamente!'
pwd
ls -la
mirror -R --delete-first --verbose --parallel=2 ./ ./
bye
"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Archivos subidos exitosamente!"
    echo "🌐 Tu sitio está en: https://imagemia.com"
    echo ""
    echo "Verifica en tu navegador: https://imagemia.com"
else
    echo "❌ Error al subir archivos"
    exit 1
fi
