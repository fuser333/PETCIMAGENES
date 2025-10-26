#!/bin/bash

# Subir archivos a Spaceship vía FTP
# Usamos lftp para transfer

FTP_HOST="ftp.imagemia.com"
FTP_USER="fwrikwglvd"
FTP_PASS="slva2BmtZOgDSQ6qOQVX"

# Instalar lftp si no existe
if ! command -v lftp &> /dev/null; then
    echo "Instalando lftp..."
    brew install lftp
fi

# Subir archivos
lftp -c "
open ftp://$FTP_USER:$FTP_PASS@$FTP_HOST
set ssl:verify-certificate no
cd public_html
mirror -R --delete-first ./ ./
bye
"

echo "✅ Archivos subidos exitosamente a imagemia.com"
