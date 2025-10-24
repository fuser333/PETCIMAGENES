#!/bin/bash

# 🧪 Script de Testing Completo para PETCIMAGENES Agent
# Este script valida que todos los componentes estén funcionando correctamente

echo "🧪 INICIANDO PRUEBAS DEL SISTEMA PETCIMAGENES"
echo "=============================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASSED=0
FAILED=0

# Función para test
run_test() {
    local test_name=$1
    local test_command=$2
    
    echo -n "🔍 Testing: $test_name... "
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASSED${NC}"
        ((PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        ((FAILED++))
        return 1
    fi
}

# ==============================================
# SECCIÓN 1: VERIFICACIONES DE ARCHIVOS
# ==============================================

echo "📁 SECCIÓN 1: Verificando estructura de archivos"
echo "------------------------------------------------"

run_test "Backend existe" "test -d backend"
run_test "Frontend existe" "test -f frontend/index.html"
run_test "Package.json existe" "test -f backend/package.json"
run_test ".env existe" "test -f backend/.env"
run_test "agentService.js existe" "test -f backend/src/services/agentService.js"
run_test "chatController.js existe" "test -f backend/src/controllers/chatController.js"
run_test "fileUpload.js existe" "test -f backend/src/utils/fileUpload.js"

echo ""

# ==============================================
# SECCIÓN 2: VERIFICACIÓN DE .ENV
# ==============================================

echo "🔑 SECCIÓN 2: Verificando variables de entorno"
echo "----------------------------------------------"

cd backend

if [ -f .env ]; then
    source .env
    
    run_test "OPENAI_API_KEY configurado" "test -n '$OPENAI_API_KEY'"
    run_test "VECTOR_STORE_ID configurado" "test -n '$VECTOR_STORE_ID'"
    run_test "API Key tiene formato correcto" "echo $OPENAI_API_KEY | grep -q '^sk-'"
    run_test "Vector Store ID tiene formato correcto" "echo $VECTOR_STORE_ID | grep -q '^vs_'"
else
    echo -e "${RED}❌ Archivo .env no encontrado${NC}"
    ((FAILED+=4))
fi

echo ""

# ==============================================
# SECCIÓN 3: DEPENDENCIAS DE NODE
# ==============================================

echo "📦 SECCIÓN 3: Verificando dependencias de Node.js"
echo "------------------------------------------------"

run_test "node_modules instalado" "test -d node_modules"
run_test "Express instalado" "npm list express --depth=0"
run_test "OpenAI SDK instalado" "npm list openai --depth=0"
run_test "Agents SDK instalado" "npm list @openai/agents --depth=0"
run_test "Multer instalado" "npm list multer --depth=0"
run_test "CORS instalado" "npm list cors --depth=0"

echo ""

# ==============================================
# SECCIÓN 4: VERIFICACIÓN DE CÓDIGO
# ==============================================

echo "💻 SECCIÓN 4: Verificando integridad del código"
echo "----------------------------------------------"

# Verificar que el fix de fileIds está aplicado
if grep -q "fileIds = \[\]" src/services/agentService.js; then
    if grep -q "type: \"input_file\"" src/services/agentService.js; then
        echo -e "🔍 Testing: Fix de fileIds aplicado... ${GREEN}✅ PASSED${NC}"
        ((PASSED++))
    else
        echo -e "🔍 Testing: Fix de fileIds aplicado... ${RED}❌ FAILED${NC}"
        echo "   El código no tiene el tipo 'input_file' para attachments"
        ((FAILED++))
    fi
else
    echo -e "🔍 Testing: Fix de fileIds aplicado... ${RED}❌ FAILED${NC}"
    echo "   El método no acepta fileIds como parámetro"
    ((FAILED++))
fi

# Verificar que streamMessage existe
if grep -q "export const streamMessage" src/controllers/chatController.js; then
    echo -e "🔍 Testing: streamMessage endpoint existe... ${GREEN}✅ PASSED${NC}"
    ((PASSED++))
else
    echo -e "🔍 Testing: streamMessage endpoint existe... ${RED}❌ FAILED${NC}"
    ((FAILED++))
fi

# Verificar que uploadFiles existe
if grep -q "export const uploadFiles" src/controllers/chatController.js; then
    echo -e "🔍 Testing: uploadFiles endpoint existe... ${GREEN}✅ PASSED${NC}"
    ((PASSED++))
else
    echo -e "🔍 Testing: uploadFiles endpoint existe... ${RED}❌ FAILED${NC}"
    ((FAILED++))
fi

echo ""

# ==============================================
# SECCIÓN 5: SINTAXIS DE JAVASCRIPT
# ==============================================

echo "🔍 SECCIÓN 5: Validando sintaxis de JavaScript"
echo "----------------------------------------------"

run_test "agentService.js sintaxis válida" "node --check src/services/agentService.js"
run_test "chatController.js sintaxis válida" "node --check src/controllers/chatController.js"
run_test "fileUpload.js sintaxis válida" "node --check src/utils/fileUpload.js"

echo ""

# ==============================================
# SECCIÓN 6: PERMISOS Y DIRECTORIOS
# ==============================================

echo "📂 SECCIÓN 6: Verificando permisos y directorios"
echo "-----------------------------------------------"

run_test "Directorio uploads existe" "test -d uploads"
run_test "Directorio uploads tiene permisos de escritura" "test -w uploads"
run_test "Directorio logs existe" "test -d ../logs"

echo ""

# ==============================================
# RESUMEN FINAL
# ==============================================

cd ..

TOTAL=$((PASSED + FAILED))
PERCENTAGE=$((PASSED * 100 / TOTAL))

echo ""
echo "=============================================="
echo "📊 RESUMEN DE PRUEBAS"
echo "=============================================="
echo ""
echo "Total de pruebas: $TOTAL"
echo -e "${GREEN}Pasadas: $PASSED${NC}"
echo -e "${RED}Fallidas: $FAILED${NC}"
echo "Porcentaje de éxito: $PERCENTAGE%"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡TODAS LAS PRUEBAS PASARON!${NC}"
    echo ""
    echo "✅ El sistema está listo para usar"
    echo ""
    echo "Para iniciar el sistema:"
    echo "1. Terminal 1: ./INICIAR_BACKEND_CORRECTO.sh"
    echo "2. Terminal 2: ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev"
    echo "3. Navegador: https://rosia-unbrocaded-distinguishedly.ngrok-free.dev"
    echo ""
    exit 0
else
    echo -e "${RED}⚠️  HAY PROBLEMAS QUE RESOLVER${NC}"
    echo ""
    echo "Por favor revisa las pruebas fallidas arriba."
    echo "Consulta SOLUCION_ARCHIVOS_COMPLETA.md para más información."
    echo ""
    exit 1
fi
