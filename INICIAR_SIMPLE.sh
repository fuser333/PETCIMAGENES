#!/bin/bash

echo "🚀 INICIANDO PETCIMAGENES AGENT - VERSIÓN SIMPLE"
echo "================================================"
echo ""

cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js no está instalado${NC}"
    exit 1
fi

# Paso 1: Instalar/verificar dependencias
echo "📦 Verificando dependencias del backend..."
cd backend

if [ ! -d "node_modules" ]; then
    echo "   Instalando dependencias..."
    npm install --silent
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Error al instalar dependencias${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Dependencias instaladas${NC}"
else
    echo -e "${GREEN}✅ Dependencias ya instaladas${NC}"
fi

echo ""

# Paso 2: Verificar .env
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ Archivo .env no encontrado${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Archivo .env encontrado${NC}"
echo ""

# Paso 3: Iniciar backend
echo "🔄 Iniciando backend en puerto 3000..."
npm start > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../logs/backend.pid

# Esperar a que el backend esté listo
sleep 3

if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${RED}❌ El backend no se inició correctamente${NC}"
    echo "Ver logs en: logs/backend.log"
    cat ../logs/backend.log
    exit 1
fi

echo -e "${GREEN}✅ Backend corriendo (PID: $BACKEND_PID)${NC}"
echo ""

# Paso 4: Servir frontend con Python
cd ../frontend
echo "🌐 Sirviendo frontend en puerto 8080..."

# Actualizar URL en app.js para usar localhost
if grep -q "https://rosia-unbrocaded-distinguishedly.ngrok-free.dev" app.js; then
    echo "   Actualizando URL a localhost..."
    sed -i '' 's|https://rosia-unbrocaded-distinguishedly.ngrok-free.dev|http://localhost:3000|g' app.js
fi

# Iniciar servidor Python
python3 -m http.server 8080 > ../logs/frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../logs/frontend.pid

sleep 2

if ! kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${RED}❌ El servidor frontend no se inició${NC}"
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

echo -e "${GREEN}✅ Frontend sirviendo (PID: $FRONTEND_PID)${NC}"
echo ""

# Resumen
echo "=========================================="
echo -e "${GREEN}✅ ¡TODO LISTO!${NC}"
echo "=========================================="
echo ""
echo "📊 SERVICIOS CORRIENDO:"
echo "   Backend:  http://localhost:3000 (PID: $BACKEND_PID)"
echo "   Frontend: http://localhost:8080 (PID: $FRONTEND_PID)"
echo ""
echo "🌐 ABRE TU NAVEGADOR EN:"
echo -e "   ${YELLOW}http://localhost:8080${NC}"
echo ""
echo "📝 LOGS:"
echo "   Backend:  tail -f logs/backend.log"
echo "   Frontend: tail -f logs/frontend.log"
echo ""
echo "🛑 PARA DETENER TODO:"
echo "   kill $BACKEND_PID $FRONTEND_PID"
echo ""
echo "=========================================="

# Abrir navegador automáticamente
sleep 1
open http://localhost:8080

# Mostrar logs del backend en tiempo real
echo ""
echo "📊 Logs del backend (Ctrl+C para salir):"
echo "------------------------------------------"
tail -f ../logs/backend.log

# Cleanup al salir
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null" EXIT
