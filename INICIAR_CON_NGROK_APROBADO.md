# 🚀 INSTRUCCIONES PARA INICIAR CON NGROK APROBADO

## ✅ URL Aprobada en OpenAI
```
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

## 🔧 PROBLEMA ENCONTRADO Y SOLUCIONADO

### ❌ Problema:
1. El chat mostraba `[object Object]` en lugar de texto
2. El backend no estaba corriendo desde la ruta correcta
3. Los eventos de streaming no tenían el formato correcto

### ✅ Solución Aplicada:
1. Corregido el formato de eventos de streaming en `chatController.js`
2. Ahora el backend envía `{content: "texto"}` en lugar de objetos complejos
3. Creado script de inicio correcto: `INICIAR_BACKEND_CORRECTO.sh`

---

## 🎯 PASOS PARA INICIAR

### 1. Abrir Terminal y Navegar al Proyecto
```bash
cd /Users/hbva/AgentkitV1
```

### 2. Ejecutar el Script de Inicio
```bash
chmod +x INICIAR_BACKEND_CORRECTO.sh
./INICIAR_BACKEND_CORRECTO.sh
```

### 3. En OTRA Terminal, Iniciar Ngrok
```bash
cd /Users/hbva/AgentkitV1
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

### 4. Verificar que Todo Funciona
Abre en tu navegador (EN INCÓGNITO):
```
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

---

## 🧪 VERIFICACIÓN RÁPIDA

### 1. Backend Corriendo
```bash
curl http://localhost:3000/health
```
Debe responder:
```json
{"status":"ok","timestamp":"...","uptime":123}
```

### 2. Ngrok Activo
```bash
curl http://localhost:4040/api/tunnels
```
Debe mostrar la URL aprobada

### 3. Chat Funcionando
1. Abre la URL en incógnito
2. Escribe "hola" en el chat
3. Debes ver la respuesta token por token (NO `[object Object]`)

---

## ⚠️ SI APARECE `[object Object]`

### Causa:
El navegador está usando una versión cacheada del código viejo

### Solución:
1. **Cierra TODAS las pestañas** de la aplicación
2. Abre **nueva ventana incógnito** (Cmd + Shift + N)
3. Pega la URL: `https://rosia-unbrocaded-distinguishedly.ngrok-free.dev`
4. Presiona **Cmd + Shift + R** para recargar sin caché

---

## 📝 CAMBIOS REALIZADOS

### Archivo Modificado:
```
backend/src/controllers/chatController.js
```

### Cambio Específico:
```javascript
// ANTES (enviaba objetos complejos):
for await (const event of stream) {
  res.write(`data: ${JSON.stringify(event)}\n\n`);
}

// AHORA (envía formato correcto):
for await (const event of stream) {
  if (event.type === 'text_delta' && event.content) {
    res.write(`data: ${JSON.stringify({ content: event.content })}\n\n`);
  } else if (event.type === 'done') {
    res.write(`data: [DONE]\n\n`);
  } else if (event.type === 'tool_call') {
    res.write(`data: ${JSON.stringify({ 
      type: 'status', 
      message: `🔧 Usando ${event.tool}...` 
    })}\n\n`);
  }
}
```

---

## 🔍 DEBUGGING

### Ver Logs en Tiempo Real
```bash
# Terminal 1: Logs del backend
tail -f logs/backend.log

# Terminal 2: Requests HTTP
# En el navegador: F12 → Network → filtrar por "stream"
```

### Si el Backend No Inicia
```bash
# Matar procesos en puerto 3000
lsof -ti:3000 | xargs kill -9

# Reinstalar dependencias
cd backend
rm -rf node_modules package-lock.json
npm install

# Intentar de nuevo
cd ..
./INICIAR_BACKEND_CORRECTO.sh
```

### Si Ngrok Falla
```bash
# Matar todos los ngrok
killall ngrok

# Verificar autenticación
ngrok config check

# Reintentar con dominio específico
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

---

## 🎯 CONFIGURACIÓN DE NGROK

### Opción 1: Con Dominio Específico (RECOMENDADO)
```bash
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

### Opción 2: Si Tienes Cuenta Pagada de Ngrok
Edita `backend/.env` y agrega:
```bash
NGROK_DOMAIN=rosia-unbrocaded-distinguishedly.ngrok-free.dev
USE_NGROK=true
```

Luego solo ejecuta:
```bash
npm start
```

Y ngrok se iniciará automáticamente con el dominio correcto.

---

## ✅ CHECKLIST DE INICIO

- [ ] Terminal abierta en `/Users/hbva/AgentkitV1`
- [ ] Ejecutado `./INICIAR_BACKEND_CORRECTO.sh`
- [ ] Backend respondiendo en `http://localhost:3000/health`
- [ ] Ngrok corriendo con dominio aprobado
- [ ] URL abriendo en navegador incógnito
- [ ] Chat respondiendo correctamente (SIN `[object Object]`)
- [ ] Upload de archivos funcional

---

## 🚨 COMANDOS DE EMERGENCIA

```bash
# Resetear TODO
lsof -ti:3000 | xargs kill -9
killall ngrok
cd /Users/hbva/AgentkitV1
./INICIAR_BACKEND_CORRECTO.sh

# En otra terminal
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

---

## 📊 ESTADO ACTUAL

✅ Frontend: Diseño corporativo PETCIMAGENES  
✅ Backend: GPT-4o configurado  
✅ Streaming: Formato corregido  
✅ Vector Store: Activo (vs_68f4701fe6c881918246bd8e88f0b974)  
✅ Ngrok: Dominio aprobado en OpenAI  
✅ Bug `[object Object]`: SOLUCIONADO  

---

## 🎉 ¡LISTO PARA USAR!

Una vez iniciado todo, ve a:
```
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

Y prueba:
1. Escribir "Hola, ¿cómo estás?"
2. Subir un archivo PDF
3. Preguntar "¿Qué documentos tienes?"

**Todo debe funcionar correctamente ahora!** 🚀
