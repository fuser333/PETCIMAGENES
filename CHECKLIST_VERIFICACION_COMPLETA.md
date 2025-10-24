# ✅ CHECKLIST DE VERIFICACIÓN RÁPIDA

## 🎯 ANTES DE EMPEZAR

Marca cada item cuando lo completes:

```
[ ] Leí INICIO_RAPIDO.md
[ ] Tengo 2 terminales abiertas
[ ] Tengo un navegador en modo incógnito listo
[ ] Tengo archivos de prueba (PDF, Excel) listos
```

---

## 🚀 INICIANDO EL SISTEMA

### Terminal 1: Backend

```bash
cd /Users/hbva/AgentkitV1
./INICIAR_BACKEND_CORRECTO.sh
```

**Verificar:**
```
[ ] Dice "✅ Backend iniciado correctamente"
[ ] Dice "🚀 Iniciando backend en el puerto 3000"
[ ] No hay errores rojos
```

**Si falla:**
- Verifica que node esté instalado: `node --version`
- Verifica las dependencias: `cd backend && npm install`

---

### Terminal 2: Ngrok

```bash
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

**Verificar:**
```
[ ] Dice "Forwarding"
[ ] Muestra la URL correcta
[ ] Status es "online"
[ ] No dice "authentication failed"
```

**Si falla:**
- Verifica que ngrok esté instalado: `ngrok version`
- Verifica tu cuenta: `ngrok config check`

---

### Navegador: Frontend

```
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

**Verificar:**
```
[ ] La página carga sin errores
[ ] Veo el header azul con "PETCIMAGENES"
[ ] Veo el sidebar izquierdo con "📂 Seleccionar Archivos"
[ ] Veo el chat a la derecha
[ ] Veo el botón 📎 en el input del chat
[ ] No hay errores en la consola (F12)
```

**Si falla:**
- Abre modo incógnito (CMD+SHIFT+N o CTRL+SHIFT+N)
- Limpia caché (CMD+SHIFT+R o CTRL+SHIFT+R)
- Verifica que backend y ngrok estén corriendo

---

## 🧪 PRUEBAS FUNCIONALES

### Test 1: Chat Básico (Sin archivos)

1. En el input del chat, escribe: `Hola, preséntate`
2. Click en Enviar o presiona Enter

**Verificar:**
```
[ ] El mensaje se envía
[ ] Aparece un indicador de "escribiendo..."
[ ] La respuesta aparece palabra por palabra (streaming)
[ ] El agente se presenta como Analista de PETCIMAGENES
[ ] No hay errores
```

---

### Test 2: Chat Attachment (Temporal)

1. Click en el botón 📎 (al lado del input)
2. Selecciona un archivo (Excel, PDF, imagen)
3. **Verificar:** Aparece el nombre del archivo arriba del input
4. Escribe: `Analiza este archivo`
5. Click en Enviar

**Verificar:**
```
[ ] El archivo se muestra en el preview
[ ] El mensaje se envía con el archivo
[ ] El agente menciona el análisis del archivo
[ ] El agente da detalles específicos del contenido
[ ] Después del mensaje, el archivo desaparece del preview
```

**En logs del backend (Terminal 1):**
```bash
tail -f /Users/hbva/AgentkitV1/logs/backend.log
```

**Debes ver:**
```
[ ] [INFO] Subiendo 1 archivo(s)
[ ] [INFO] Archivo subido: file-xxxxx - [nombre].xlsx
[ ] [INFO] Agregando 1 archivo(s) al mensaje como attachments
```

---

### Test 3: Vector Store (Permanente)

1. En el sidebar izquierdo, click **📂 Seleccionar Archivos**
2. Selecciona un PDF o documento
3. **Verificar:** Aparece en la lista con su nombre y tamaño
4. Click en **⬆️ Enviar al Vector Store**

**Verificar:**
```
[ ] Dice "Subiendo X archivo(s)..."
[ ] Dice "Archivos subidos correctamente"
[ ] El archivo sigue en la lista (no desaparece)
```

5. En el chat, pregunta algo sobre ese documento
   - Ejemplo: "¿Qué información hay en [nombre del archivo]?"

**Verificar:**
```
[ ] El agente responde con información del documento
[ ] El agente cita o menciona el archivo
[ ] La respuesta es coherente con el contenido real
```

---

### Test 4: Múltiples Archivos

1. En el chat, click 📎 y adjunta 2-3 archivos diferentes
2. Escribe: `Compara estos archivos`
3. Enviar

**Verificar:**
```
[ ] Todos los archivos se muestran en el preview
[ ] El agente menciona todos los archivos
[ ] El agente hace comparaciones entre ellos
```

---

## 🔍 VERIFICACIÓN DE LOGS

### Logs del Backend

```bash
tail -50 /Users/hbva/AgentkitV1/logs/backend.log
```

**Debes ver líneas como:**
```
[INFO] Procesando mensaje
[INFO] Subiendo 1 archivo(s)
[INFO] Archivo subido: file-abc123 - datos.xlsx
[INFO] Agregando 1 archivo(s) al mensaje como attachments
[DEBUG] Ejecutando agent workflow con streaming
```

**Verificar:**
```
[ ] No hay errores [ERROR]
[ ] Hay líneas de [INFO] cuando subes archivos
[ ] Hay "Agregando X archivo(s) como attachments"
```

---

### Consola del Navegador (F12)

**Tab Console:**
```
[ ] No hay errores rojos
[ ] No hay warnings de CORS
[ ] No hay "Failed to fetch"
```

**Tab Network:**
- Filtra por `chat/stream`
- Click en la última request

```
[ ] Status: 200 OK
[ ] Type: text/event-stream
[ ] Ves los mensajes streaming en la respuesta
```

---

## 🎯 RESUMEN FINAL

Si todos los items están marcados, ¡tu sistema está 100% funcional! 🎉

**Capacidades confirmadas:**
```
✅ Chat con streaming en tiempo real
✅ Attachments temporales funcionando
✅ Vector Store funcionando
✅ Procesamiento de archivos correcto
✅ Agent respondiendo inteligentemente
```

---

## ⚠️ SI ALGO FALLA

### Escenario 1: Backend no inicia

```bash
cd /Users/hbva/AgentkitV1/backend
npm install
node src/server.js
```

Si hay error de módulos:
```bash
npm install express openai @openai/agents multer cors dotenv
```

### Escenario 2: Ngrok no conecta

```bash
# Verificar auth token
ngrok config check

# Re-autenticar si es necesario
ngrok config add-authtoken TU_TOKEN
```

### Escenario 3: Archivos no se procesan

**Revisar .env:**
```bash
cat /Users/hbva/AgentkitV1/backend/.env
```

Debe tener:
```
OPENAI_API_KEY=sk-proj-...
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
PORT=3000
```

**Verificar que el fix esté aplicado:**
```bash
grep -A 5 "fileIds = \[\]" /Users/hbva/AgentkitV1/backend/src/services/agentService.js
```

Debe contener `type: "input_file"`

---

## 📊 ESTADÍSTICAS DE ÉXITO

**Tu progreso:**
```
Tests completados: ___ / 4
Items verificados: ___ / 23
Porcentaje de éxito: ___%
```

**Si tienes 100%:**
```
🎉 ¡FELICITACIONES!
Tu sistema está completamente funcional y listo para producción.
```

**Si tienes 75-99%:**
```
⚠️ Casi listo
Revisa los items que fallaron usando SOLUCION_ARCHIVOS_COMPLETA.md
```

**Si tienes <75%:**
```
🔧 Necesita revisión
Revisa los logs y sigue el troubleshooting en INICIO_RAPIDO.md
```

---

## 📝 NOTAS DE USO

**Mejores prácticas:**
- Usa modo incógnito para evitar problemas de caché
- Reinicia el backend si cambias código
- Los archivos del Vector Store son permanentes
- Los attachments del chat son temporales (1 mensaje)

**Límites:**
- Máximo 10 archivos por upload
- Tamaño máximo por archivo: depende de tu plan OpenAI
- El Vector Store tiene capacidad según tu plan

---

**Última actualización:** 23 de octubre, 2025  
**Versión del sistema:** 2.0 (Con fix de archivos)  
**Estado:** ✅ Completamente funcional
