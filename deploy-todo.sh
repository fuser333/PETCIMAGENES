#!/bin/bash

# ============================================
# Script de Deploy Completo PETCIMAGENES
# ============================================

echo "🚀 Deploy Completo de PETCIMAGENES"
echo "===================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paso 1: Verificar que estemos en el directorio correcto
echo -e "${BLUE}📍 Verificando ubicación...${NC}"
if [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: Ejecuta este script desde la carpeta AgentkitV1"
    exit 1
fi
echo -e "${GREEN}✅ Ubicación correcta${NC}"
echo ""

# Paso 2: Verificar instalación de Vercel CLI
echo -e "${BLUE}🔍 Verificando Vercel CLI...${NC}"
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}⚠️  Vercel CLI no instalado. Instalando...${NC}"
    npm install -g vercel
fi
echo -e "${GREEN}✅ Vercel CLI listo${NC}"
echo ""

# Paso 3: Deploy del Backend
echo -e "${BLUE}🚀 Desplegando Backend en Vercel...${NC}"
echo ""
cd backend

# Ejecutar deploy
vercel --prod

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Backend desplegado exitosamente!${NC}"
    echo ""
    echo -e "${YELLOW}📋 IMPORTANTE: Copia la URL que te dio Vercel arriba${NC}"
    echo -e "${YELLOW}   (algo como: https://petcimagenes-backend-xxxxx.vercel.app)${NC}"
    echo ""
    echo -e "${BLUE}📝 Siguiente paso:${NC}"
    echo "   1. Abre: web/deploy/empresas/petcimagenes/index.html"
    echo "   2. Busca: const API_URL = 'http://localhost:3000'"
    echo "   3. Cámbiala por la URL de Vercel"
    echo "   4. Sube el archivo actualizado a FTP"
    echo ""
    echo -e "${GREEN}✅ Todo listo! El sistema está funcionando.${NC}"
else
    echo ""
    echo -e "❌ Error en el deploy. Revisa los mensajes arriba."
    exit 1
fi

cd ..
