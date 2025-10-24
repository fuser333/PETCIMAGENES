#!/bin/bash

echo "🚀 INICIANDO PETCIMAGENES AGENT - VERSIÓN NODE"
echo "=============================================="
echo ""

cd /Users/hbva/AgentkitV1

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Paso 1: Verificar dependencias backend
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

# Verificar .env
if [ ! -f ".env" ]; then
    echo -e "${RED}❌ Archivo .env no encontrado${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Archivo .env encontrado${NC}"
echo ""

# Crear carpeta logs si no existe
mkdir -p ../logs

# Paso 2: Iniciar backend
echo "🔄 Iniciando backend en puerto 3000..."
npm start > ../logs/backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../logs/backend.pid

sleep 3

if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${RED}❌ El backend no se inició correctamente${NC}"
    echo "Ver logs:"
    cat ../logs/backend.log
    exit 1
fi

echo -e "${GREEN}✅ Backend corriendo (PID: $BACKEND_PID)${NC}"
echo ""

# Paso 3: Instalar http-server si no existe
cd ..
if ! command -v http-server &> /dev/null; then
    echo "📦 Instalando http-server..."
    npm install -g http-server --silent
    if [ $? -ne 0 ]; then
        echo -e "${YELLOW}⚠️  No se pudo instalar http-server globalmente${NC}"
        echo "   Usando npx como alternativa..."
    fi
fi

# Paso 4: Servir frontend
cd frontend
echo "🌐 Sirviendo frontend en puerto 8080..."

# Actualizar URL a localhost si es necesario
if grep -q "https://rosia-unbrocaded-distinguishedly.ngrok-free.dev" app.js 2>/dev/null; then
    echo "   Actualizando URL a localhost..."
    sed -i '' 's|https://rosia-unbrocaded-distinguishedly.ngrok-free.dev|http://localhost:3000|g' app.js 2>/dev/null || \
    sed -i 's|https://rosia-unbrocaded-distinguishedly.ngrok-free.dev|http://localhost:3000|g' app.js 2>/dev/null
fi

# Intentar con http-server o npx
if command -v http-server &> /dev/null; then
    http-server -p 8080 --cors > ../logs/frontend.log 2>&1 &
    FRONTEND_PID=$!
else
    npx http-server -p 8080 --cors > ../logs/frontend.log 2>&1 &
    FRONTEND_PID=$!
fi

echo $FRONTEND_PID > ../logs/frontend.pid
sleep 2

if ! kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${RED}❌ El servidor frontend no se inició${NC}"
    echo ""
    echo "Intentando con Python como alternativa..."
    
    if command -v python3 &> /dev/null; then
        python3 -m http.server 8080 > ../logs/frontend.log 2>&1 &
        FRONTEND_PID=$!
        echo $FRONTEND_PID > ../logs/frontend.pid
        sleep 2
        
        if ! kill -0 $FRONTEND_PID 2>/dev/null; then
            echo -e "${RED}❌ Ningún servidor funcionó${NC}"
            kill $BACKEND_PID 2>/dev/null
            exit 1
        fi
    else
        echo -e "${RED}❌ No se pudo iniciar servidor frontend${NC}"
        kill $BACKEND_PID 2>/dev/null
        exit 1
    fi
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
echo -e "${YELLOW}🌐 ABRE TU NAVEGADOR EN:${NC}"
echo -e "   ${GREEN}http://localhost:8080${NC}"
echo ""
echo "📝 LOGS:"
echo "   Backend:  tail -f logs/backend.log"
echo "   Frontend: tail -f logs/frontend.log"
echo ""
echo "🛑 PARA DETENER TODO:"
echo "   kill $BACKEND_PID $FRONTEND_PID"
echo ""
echo "=========================================="

# Abrir navegador
sleep 1
if command -v open &> /dev/null; then
    open http://localhost:8080
elif command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:8080
fi

# Mostrar logs del backend
echo ""
echo "📊 Logs del backend (Ctrl+C para salir):"
echo "------------------------------------------"
tail -f ../logs/backend.log

# Cleanup al salir
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; echo; echo 'Servicios detenidos'" EXIT
