# 🧪 GUÍA DE PRUEBAS - PETCIMAGENES Agent System

## ✅ CONFIGURACIÓN COMPLETADA

### Archivos Configurados:
- ✅ `.env` - API Key y Workflow ID configurados
- ✅ `agentService.js` - Agent workflow implementado
- ✅ Todas las dependencias instaladas

### Configuración Activa:
```
OPENAI_API_KEY: sk-proj-zKRB... (configurada)
WORKFLOW_ID: wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8
```

---

## 🚀 PASO 1: INICIAR EL BACKEND

Abre una terminal y ejecuta:

```bash
cd /Users/hbva/AgentkitV1/backend
npm run dev
```

**Deberías ver:**
```
[INFO] Server running on http://localhost:3000
```

---

## 🌐 PASO 2: EXPONER CON NGROK

Abre **OTRA terminal** y ejecuta:

```bash
ngrok http 3000
```

**Copia la URL** que te da ngrok, algo como:
```
https://xxxx-yyyy-zzzz.ngrok-free.app
```

---

## 📝 PASO 3: ACTUALIZAR EL FRONTEND

En **OTRA terminal nueva**:

```bash
cd /Users/hbva/AgentkitV1/frontend
nano app.js
```

Busca esta línea:
```javascript
const API_BASE_URL = 'http://localhost:3000';
```

Cámbiala a (usa TU URL de ngrok):
```javascript
const API_BASE_URL = 'https://TU-URL-NGROK.ngrok-free.app';
```

Guarda: `Ctrl+O` → Enter → `Ctrl+X`

---

## 🎯 PASO 4: ABRIR EL FRONTEND

```bash
cd /Users/hbva/AgentkitV1/frontend
open index.html
```

O con servidor local:
```bash
python3 -m http.server 8080
# Luego abre: http://localhost:8080
```

---

## 🧪 PRUEBAS SUGERIDAS

### Prueba 1: Verificación Básica
```
Usuario: Hola, ¿cuál es tu función?
Esperado: El agente debe responder identificándose como Analista Estratégico de PETCIMAGENES
```

### Prueba 2: Consulta Estratégica
```
Usuario: ¿Cuál es la situación actual de PETCIMAGENES?
Esperado: Debe usar File Search y proporcionar información estratégica
```

### Prueba 3: Análisis de Competencia
```
Usuario: Compara PETCIMAGENES con SOLCA
Esperado: Debe buscar en documentos internos y web si es necesario
```

### Prueba 4: Streaming
```
Usuario: Dame un análisis detallado del sector de diagnóstico por imagen en Ecuador
Esperado: La respuesta debe aparecer palabra por palabra en tiempo real
```

---

## 🔍 MONITOREO

### Terminal 1 (Backend):
Deberías ver logs como:
```
[INFO] POST /api/chat/stream
[DEBUG] Ejecutando agent workflow con streaming
[streaming] chunk received
[streaming] completed
```

### Terminal 2 (ngrok):
Verás las peticiones HTTP:
```
POST /api/chat/stream    200 OK
```

### Browser (DevTools - F12):
1. Abre la pestaña "Network"
2. Filtra por "stream"
3. Verás la petición en tiempo real con status 200

---

## ⚠️ TROUBLESHOOTING

### Error: "Cannot connect to server"
- Verifica que el backend esté corriendo (Terminal 1)
- Verifica que ngrok esté activo (Terminal 2)
- Verifica que la URL en `app.js` sea correcta

### Error: "401 Unauthorized"
- Verifica el `.env`
- Reinicia el servidor backend

### No hay streaming:
- Abre DevTools (F12) → Network
- Busca la petición `/api/chat/stream`
- Verifica el Response

### CORS error:
- El backend ya tiene CORS configurado
- Si persiste, verifica que uses la URL correcta de ngrok

---

## 📊 ARQUITECTURA DEL FLUJO

```
Frontend (HTML/JS)
    ↓ HTTP POST con mensaje del usuario
    ↓
ngrok → https://tu-url.ngrok-free.app
    ↓
Backend (Express en localhost:3000)
    ↓ Ejecuta agentService.js
    ↓
OpenAI Agents SDK
    ↓ usa workflow_id: wf_68f441fe...
    ↓
Agent PETCIMAGENES
    ├─ File Search (documentos internos)
    ├─ Web Search (información externa)
    └─ Code Interpreter (cálculos)
    ↓
Respuesta streaming ← ← ← 
```

---

## 🔐 SEGURIDAD POST-PRUEBA

**IMPORTANTE:** Tu API key está configurada. Después de probar:

1. **Considera rotar la key** en OpenAI Dashboard
2. **Nunca** subas el `.env` a GitHub (ya está en `.gitignore`)
3. **Limita** el uso de la key

---

## 📞 SOPORTE

Si algo no funciona:
1. Revisa los logs del backend (Terminal 1)
2. Revisa los logs de ngrok (Terminal 2)
3. Abre DevTools del navegador (F12)
4. Comparte los errores específicos para ayuda

---

## ✨ PRÓXIMOS PASOS

Una vez que todo funcione:
- Personaliza las instrucciones del agente
- Ajusta los parámetros de reasoning
- Añade más herramientas si es necesario
- Implementa autenticación
- Despliega en producción

---

**¡Todo está listo para probar! 🚀**
