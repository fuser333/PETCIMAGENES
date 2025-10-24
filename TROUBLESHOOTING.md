# 🔧 TROUBLESHOOTING - PETCIMAGENES AI

## 🚨 Problemas Comunes y Soluciones

---

## 1. FRONTEND - Diseño viejo se muestra en el navegador

### Síntomas:
- Ves un diseño diferente al esperado
- No aparece el header azul de PETCIMAGENES
- No está el botón verde "Subir Archivos"

### Causa:
Caché agresivo del navegador

### Solución 1: Modo Incógnito (RECOMENDADO)
```bash
# Chrome/Edge/Brave
Cmd + Shift + N (Mac)
Ctrl + Shift + N (Windows)

# Safari
Cmd + Shift + P
```

### Solución 2: Recargar sin caché
```bash
# En el navegador
Cmd + Shift + R (Mac)
Ctrl + Shift + R (Windows)
```

### Solución 3: Limpiar caché manualmente
```bash
# Chrome DevTools
1. Presiona F12
2. Click derecho en el botón de recargar
3. Selecciona "Vaciar caché y recargar forzadamente"
```

### Solución 4: Limpiar todo el caché
```bash
# Chrome
Cmd + Shift + Delete → Limpiar datos

# Safari
Cmd + Option + E → Vaciar cachés
```

---

## 2. BACKEND - Puerto 3000 ya está en uso

### Síntomas:
```
Error: listen EADDRINUSE: address already in use :::3000
```

### Solución:
```bash
# Matar proceso en puerto 3000
lsof -ti:3000 | xargs kill -9

# Esperar 2 segundos
sleep 2

# Reiniciar
./INICIAR_NGROK.sh
```

---

## 3. NGROK - No se puede obtener URL pública

### Síntomas:
- El script dice "No se pudo obtener URL de ngrok"
- curl a localhost:4040 falla

### Solución 1: Verificar instalación
```bash
# Ver versión
ngrok version

# Si no está instalado
brew install ngrok

# O descargar desde
https://ngrok.com/download
```

### Solución 2: Matar procesos ngrok zombies
```bash
# Matar todos los ngrok
killall ngrok

# Esperar 2 segundos
sleep 2

# Reiniciar
./INICIAR_NGROK.sh
```

### Solución 3: Verificar cuenta de ngrok
```bash
# Verificar autenticación
ngrok config check

# Si no estás autenticado
ngrok config add-authtoken TU_TOKEN
```

---

## 4. UPLOAD - Archivos no se suben al Vector Store

### Síntomas:
- Click en "Subir Archivos" no hace nada
- Aparece error en consola del navegador
- Archivos no aparecen en la lista

### Solución 1: Verificar VECTOR_STORE_ID
```bash
cd /Users/hbva/AgentkitV1/backend
grep VECTOR_STORE_ID .env
```
Debe mostrar: `VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974`

### Solución 2: Verificar permisos de carpeta uploads
```bash
cd /Users/hbva/AgentkitV1/backend
ls -la uploads/

# Si no existe, crearla
mkdir -p uploads
chmod 755 uploads
```

### Solución 3: Verificar API Key de OpenAI
```bash
cd /Users/hbva/AgentkitV1/backend
grep OPENAI_API_KEY .env | head -c 50
```
Debe comenzar con `sk-proj-`

### Solución 4: Ver logs del backend
```bash
tail -f logs/backend.log
```
Busca líneas con "Error" o "Failed"

---

## 5. CHAT - No recibe respuestas del AI

### Síntomas:
- Escribes un mensaje pero no hay respuesta
- Se queda mostrando "escribiendo..." infinitamente
- Error en consola del navegador

### Solución 1: Verificar endpoint
```bash
# En DevTools (F12) → Network
# Buscar request a /api/chat/stream
# Debe mostrar Status: 200
```

### Solución 2: Verificar logs
```bash
tail -30 logs/backend.log
```
Busca mensajes de error relacionados con OpenAI

### Solución 3: Probar el health endpoint
```bash
curl http://localhost:3000/health
```
Debe responder:
```json
{"status":"ok","timestamp":"...","uptime":123}
```

### Solución 4: Verificar el modelo
Edita `backend/src/services/agentService.js`
```javascript
model: "gpt-4o" // Debe ser exactamente esto
```

---

## 6. STREAMING - Respuestas no aparecen token por token

### Síntomas:
- La respuesta aparece toda de golpe al final
- No ves el efecto de escritura progresiva

### Causa:
Frontend usando endpoint incorrecto

### Solución:
Verifica que en `frontend/index.html` la línea sea:
```javascript
const response = await fetch('/api/chat/stream', {
```
NO `/api/chat`

---

## 7. NODE_MODULES - Error de dependencias

### Síntomas:
```
Error: Cannot find module 'express'
Error: Cannot find module '@openai/agents'
```

### Solución:
```bash
cd /Users/hbva/AgentkitV1/backend

# Limpiar todo
rm -rf node_modules package-lock.json

# Reinstalar
npm install

# Verificar instalación
npm list express
npm list @openai/agents
npm list openai
```

---

## 8. OPENAI API - Errores de autenticación

### Síntomas:
```
Error: Incorrect API key provided
Error: Rate limit exceeded
Error: Invalid vector store ID
```

### Solución 1: Verificar API Key
```bash
cd backend
cat .env | grep OPENAI_API_KEY
```
Debe comenzar con `sk-proj-`

### Solución 2: Verificar en OpenAI Platform
1. Ve a https://platform.openai.com/api-keys
2. Verifica que tu key esté activa
3. Verifica que tengas créditos disponibles

### Solución 3: Regenerar la key
1. En OpenAI Platform, genera una nueva key
2. Actualiza `.env` con la nueva key
3. Reinicia el backend

---

## 9. VECTOR STORE - No encuentra documentos

### Síntomas:
- AI dice "No encontré información sobre..."
- File Search no funciona

### Solución 1: Verificar ID del Vector Store
```bash
cd backend
grep VECTOR_STORE_ID .env
```

### Solución 2: Verificar archivos en Vector Store
Ve a https://platform.openai.com/storage/vector_stores
y verifica que `vs_68f4701fe6c881918246bd8e88f0b974` tenga archivos

### Solución 3: Subir archivos manualmente
1. Ve a https://platform.openai.com/storage/vector_stores
2. Abre el vector store
3. Sube archivos manualmente
4. Espera a que se procesen (status: completed)

---

## 10. PERFORMANCE - Respuestas muy lentas

### Síntomas:
- Tarda más de 10 segundos en responder
- El streaming es muy lento

### Solución 1: Verificar modelo
Debe ser GPT-4o, no o1-preview:
```javascript
// En agentService.js
model: "gpt-4o"
```

### Solución 2: Verificar conexión a internet
```bash
ping openai.com
```

### Solución 3: Reducir tamaño de documentos
Vector Store muy grande puede ralentizar:
- Elimina documentos innecesarios
- Divide documentos grandes en partes

---

## 🆘 RESETEO COMPLETO

Si nada funciona, resetea todo:

```bash
cd /Users/hbva/AgentkitV1

# 1. Matar todos los procesos
lsof -ti:3000 | xargs kill -9
killall ngrok

# 2. Limpiar node_modules
cd backend
rm -rf node_modules package-lock.json

# 3. Reinstalar dependencias
npm install

# 4. Verificar .env
cat .env

# 5. Limpiar logs
cd ..
rm -f logs/*.log
mkdir -p logs

# 6. Reiniciar
./INICIAR_NGROK.sh
```

---

## 📞 OBTENER AYUDA

### Logs importantes:
```bash
# Backend
tail -50 logs/backend.log

# Ngrok
tail -50 logs/ngrok.log

# Consola del navegador
# F12 → Console
```

### Información del sistema:
```bash
# Node.js
node --version
npm --version

# Ngrok
ngrok version

# Procesos corriendo
ps aux | grep node
ps aux | grep ngrok

# Puertos en uso
lsof -i :3000
lsof -i :4040
```

---

## 🐛 DEBUG MODE

Para debugging avanzado:

### 1. Activar logs detallados
En `backend/src/config/logger.js`:
```javascript
level: 'debug' // Cambiar de 'info' a 'debug'
```

### 2. Ver requests HTTP
En DevTools (F12):
- Network → All
- Preserve log activado
- Disable cache activado

### 3. Ver websockets
En DevTools (F12):
- Network → WS
- Observar conexiones de streaming

---

## ✅ VERIFICACIÓN POST-FIX

Después de resolver un problema:

```bash
# 1. Health check
curl http://localhost:3000/health

# 2. Test upload
curl -X POST http://localhost:3000/api/upload \
  -F "files=@test.txt"

# 3. Test chat
curl -X POST http://localhost:3000/api/chat/stream \
  -H "Content-Type: application/json" \
  -d '{"message":"hola"}'

# 4. Abrir en navegador
open http://localhost:3000
```

---

**Última actualización:** Octubre 2025
