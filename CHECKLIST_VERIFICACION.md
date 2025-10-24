# ✅ CHECKLIST DE VERIFICACIÓN - PETCIMAGENES

## 🎯 Antes de comenzar

- [ ] Node.js instalado (v18 o superior)
- [ ] npm instalado
- [ ] ngrok instalado (`brew install ngrok`)
- [ ] API Key de OpenAI válida

---

## 🔧 Verificación del Backend

```bash
cd /Users/hbva/AgentkitV1/backend
```

### 1. Verificar dependencias
```bash
npm list express cors openai @openai/agents multer
```
✅ Debe mostrar todas las dependencias instaladas

### 2. Verificar .env
```bash
cat .env
```
✅ Debe tener:
- `OPENAI_API_KEY=sk-proj-...`
- `VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974`
- `WORKFLOW_ID=wf_...`
- `PORT=3000`

### 3. Verificar archivos críticos
```bash
ls -la src/app.js
ls -la src/services/agentService.js
ls -la src/controllers/chatController.js
ls -la src/utils/fileUpload.js
```
✅ Todos deben existir

---

## 🎨 Verificación del Frontend

```bash
cd /Users/hbva/AgentkitV1/frontend
```

### 1. Verificar index.html
```bash
wc -l index.html
```
✅ Debe tener más de 500 líneas (el nuevo diseño)

### 2. Verificar contenido
```bash
grep "PETCIMAGENES" index.html
grep "#284A89" index.html
grep "/api/upload" index.html
```
✅ Todos deben dar resultados

---

## 🚀 Iniciar el Sistema

### 1. Ejecutar script
```bash
cd /Users/hbva/AgentkitV1
./INICIAR_NGROK.sh
```

### 2. Verificar que el backend está corriendo
```bash
curl http://localhost:3000/health
```
✅ Debe responder: `{"status":"ok",...}`

### 3. Verificar ngrok
```bash
curl http://localhost:4040/api/tunnels
```
✅ Debe mostrar la URL pública

---

## 🌐 Verificación en el Navegador

### 1. Abrir en incógnito
- Chrome/Edge: `Cmd + Shift + N`
- Safari: `Cmd + Shift + P`

### 2. Ir a la URL pública
`https://xxxx-xxxx.ngrok-free.app`

### 3. Verificar elementos visuales
- [ ] Header azul con logo "P"
- [ ] Texto "PETCIMAGENES"
- [ ] Botón verde "Subir Archivos (Máx. 10)"
- [ ] Área de chat a la derecha
- [ ] Input de mensaje en la parte inferior
- [ ] Botón "Enviar ✉️"

### 4. Verificar funcionalidad
- [ ] Click en "Subir Archivos" abre selector
- [ ] Escribir mensaje en el input funciona
- [ ] Presionar Enter envía el mensaje
- [ ] Click en "Enviar ✉️" envía el mensaje

---

## 📤 Test de Upload de Archivos

### 1. Preparar archivos de prueba
```bash
cd /Users/hbva/AgentkitV1
echo "Documento de prueba" > test.txt
```

### 2. Subir desde la interfaz
- [ ] Click en "Subir Archivos"
- [ ] Seleccionar `test.txt`
- [ ] Ver que aparece en la lista de archivos
- [ ] Ver mensaje de confirmación

### 3. Verificar en logs
```bash
tail -f logs/backend.log
```
✅ Debe mostrar: "Subiendo archivo al vector store..."

---

## 💬 Test del Chat

### 1. Enviar mensaje simple
Escribir: `Hola, ¿cómo estás?`
- [ ] Mensaje aparece en el chat
- [ ] Respuesta del AI aparece con streaming
- [ ] No hay errores en consola

### 2. Pregunta sobre documentos
Escribir: `¿Qué documentos tienes disponibles?`
- [ ] AI responde con información del Vector Store
- [ ] Respuesta es coherente

### 3. Pregunta específica
Escribir: `Analiza el organigrama de PETCIMAGENES`
- [ ] AI busca en File Search
- [ ] Responde con información relevante
- [ ] Cita fuentes si aplica

---

## 🔍 Verificación de Logs

### Backend Log
```bash
tail -20 logs/backend.log
```
✅ No debe tener errores críticos

### Consola del Navegador
Presiona `F12` → Console
✅ No debe tener errores rojos

---

## 🐛 Si algo falla

### Backend no inicia
```bash
# Limpiar puerto
lsof -ti:3000 | xargs kill -9

# Reinstalar dependencias
cd backend
rm -rf node_modules package-lock.json
npm install

# Reintentar
npm start
```

### Frontend muestra diseño viejo
```bash
# En el navegador
Cmd + Shift + R  # Recargar sin caché

# O eliminar caché
Cmd + Option + E  # Chrome DevTools
Application → Clear storage → Clear site data
```

### Archivos no se suben
```bash
# Verificar Vector Store ID
grep VECTOR_STORE_ID backend/.env

# Verificar permisos
ls -la backend/uploads/

# Crear carpeta si no existe
mkdir -p backend/uploads
chmod 755 backend/uploads
```

---

## ✨ Todo Funcionando

Si todos los checks están verdes:
- ✅ Backend corriendo
- ✅ Frontend cargando
- ✅ Chat funcionando
- ✅ Upload funcionando
- ✅ Streaming funcionando
- ✅ Sin errores en logs

**¡Estás listo para usar PETCIMAGENES AI Assistant!** 🎉

---

## 📊 Monitoreo Continuo

Mantén abierta una terminal con:
```bash
tail -f logs/backend.log
```

Y el navegador con DevTools abierto (F12) en la pestaña Network para ver:
- Requests a `/api/upload`
- Requests a `/api/chat/stream`
- Streaming de respuestas

---

**Última verificación:** Octubre 2025
