# 🚀 INICIO RÁPIDO - Sistema Arreglado y Listo

## ✅ LO QUE SE ARREGLÓ HOY

**Problema:** Los archivos se subían a OpenAI pero el agente no los procesaba.

**Solución:** Modificamos `agentService.js` para pasar correctamente los fileIds como attachments del tipo `input_file`.

**Estado actual:** ✅ **100% FUNCIONAL**

---

## 🎯 3 PASOS PARA USAR EL SISTEMA

### PASO 1: Iniciar Backend (Terminal 1)

```bash
cd /Users/hbva/AgentkitV1
./INICIAR_BACKEND_CORRECTO.sh
```

✅ Deberías ver: `✅ Backend iniciado correctamente`

### PASO 2: Iniciar Ngrok (Terminal 2)

```bash
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

✅ Deberías ver: `Forwarding   https://rosia-unbrocaded-distinguishedly.ngrok-free.dev`

### PASO 3: Abrir en Navegador (Incógnito)

```
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

✅ Deberías ver: La interfaz del chat con sidebar de archivos

---

## 💡 USO DEL SISTEMA

### Opción A: Archivos Temporales (Chat Attachments)

**Para archivos que solo quieres usar en UN mensaje:**

1. Click en botón **📎** al lado del input
2. Selecciona archivo (PDF, Excel, imágenes, etc.)
3. Escribe tu pregunta
4. Click **Enviar**

**Ejemplo:**
- Adjunta: `ventas_octubre.xlsx`
- Pregunta: "¿Cuál fue el producto más vendido?"

### Opción B: Archivos Permanentes (Vector Store)

**Para archivos que el agente debe recordar siempre:**

1. En el sidebar izquierdo, click **📂 Seleccionar Archivos**
2. Selecciona uno o varios archivos
3. Click **⬆️ Enviar al Vector Store**
4. El archivo queda guardado permanentemente

**Ejemplo:**
- Sube: `manual_equipos.pdf`
- Luego pregunta: "¿Cómo se calibra el PET-CT?"
- El agente buscará en el manual automáticamente

---

## 🧪 PRUEBA RÁPIDA (1 minuto)

### Test 1: Chat Simple (Sin archivos)

```
TÚ: Hola, ¿cómo te llamas?
AGENTE: Soy el Analista Estratégico Principal de PETCIMAGENES...
```

✅ Si responde = Backend funcionando

### Test 2: Attachment Temporal

1. Click en 📎
2. Selecciona cualquier archivo
3. Escribe: "Describe este archivo"
4. Enviar

✅ Si analiza el archivo = Sistema completo funcionando

### Test 3: Vector Store

1. Sidebar → 📂 Seleccionar Archivos
2. Sube un PDF
3. Click ⬆️ Enviar al Vector Store
4. Pregunta sobre el contenido del PDF

✅ Si encuentra info del PDF = Vector Store funcionando

---

## 🔍 VERIFICAR QUE FUNCIONA

### Logs del Backend

```bash
tail -f /Users/hbva/AgentkitV1/logs/backend.log
```

**Debes ver:**
```
[INFO] Subiendo 1 archivo(s)
[INFO] Archivo subido: file-abc123 - archivo.pdf
[INFO] Agregando 1 archivo(s) al mensaje como attachments
```

✅ Si ves estos logs = Los archivos se están procesando correctamente

---

## 🆘 SOLUCIÓN DE PROBLEMAS

### Problema 1: "Cannot connect"

**Solución:**
```bash
# Verificar que el backend esté corriendo
ps aux | grep node

# Si no está corriendo:
cd /Users/hbva/AgentkitV1
./INICIAR_BACKEND_CORRECTO.sh
```

### Problema 2: "Error al procesar el mensaje"

**Solución:**
```bash
# Limpiar caché del navegador
# Mac: CMD + SHIFT + R
# Windows: CTRL + SHIFT + R

# O usar modo incógnito
```

### Problema 3: El agente no menciona los archivos

**Verificar:**
```bash
# Ver logs
tail -20 /Users/hbva/AgentkitV1/logs/backend.log

# Buscar esta línea:
# [INFO] Agregando X archivo(s) al mensaje como attachments
```

Si no aparece, revisar que el archivo .env tenga:
```bash
cat /Users/hbva/AgentkitV1/backend/.env
```

Debe contener:
```
OPENAI_API_KEY=sk-...
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
```

---

## 📚 DOCUMENTACIÓN COMPLETA

Para información detallada:
- 📖 **SOLUCION_ARCHIVOS_COMPLETA.md** - Guía técnica completa
- 📋 **RESUMEN_SESION.md** - Resumen de lo hecho anteriormente

---

## 🎉 ¡TODO LISTO!

Tu sistema está completamente funcional con:

✅ Chat en tiempo real con streaming  
✅ Attachments temporales para análisis puntual  
✅ Vector Store para conocimiento permanente  
✅ Búsqueda web integrada  
✅ Interpretación de código Python  
✅ Análisis de PDFs, Excel, imágenes, etc.

**¡Empieza a usarlo ahora!** 🚀

---

## 📞 REFERENCIA RÁPIDA

**URLs:**
- Frontend: https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
- Backend: http://localhost:3000
- OpenAI Platform: https://platform.openai.com/storage/files

**Comandos:**
```bash
# Iniciar backend
./INICIAR_BACKEND_CORRECTO.sh

# Iniciar ngrok
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev

# Ver logs
tail -f logs/backend.log

# Detener backend
ps aux | grep node | grep -v grep | awk '{print $2}' | xargs kill
```

**IDs importantes:**
- Vector Store: `vs_68f4701fe6c881918246bd8e88f0b974`
- Agent: PETCIMAGENES
- Modelo: GPT-4o

---

**Última actualización:** 23 de octubre, 2025  
**Estado:** ✅ Sistema completamente funcional
