# 📎 HABILITAR BOTÓN DE SUBIR ARCHIVOS

## ❌ PROBLEMA:
No ves el botón verde "📎 Subir Archivos (Máx. 10)" en el sidebar izquierdo.

## ✅ CAUSA:
El navegador está usando una versión cacheada antigua del HTML. El código **SÍ tiene el botón**, solo necesitas forzar la recarga.

---

## 🚀 SOLUCIÓN RÁPIDA (RECOMENDADA):

### Opción 1: Forzar Recarga con Script
```bash
cd /Users/hbva/AgentkitV1
chmod +x FORZAR_RECARGA.sh
./FORZAR_RECARGA.sh
```

Luego:
1. **Cierra TODAS** las pestañas de la aplicación
2. Abre **NUEVA ventana incógnito** (Cmd + Shift + N)
3. Ve a: `https://rosia-unbrocaded-distinguishedly.ngrok-free.dev`

### Opción 2: Recarga Manual Agresiva
1. Abre la app en el navegador
2. Presiona **Cmd + Option + I** (abrir DevTools)
3. Haz **click derecho** en el botón de recargar del navegador
4. Selecciona **"Vaciar caché y recargar forzadamente"**
5. Cierra DevTools

### Opción 3: Limpiar Todo el Caché
1. En Safari/Chrome: **Cmd + Shift + Delete**
2. Selecciona "Último día" o "Todo"
3. Marca "Cachés" o "Imágenes y archivos en caché"
4. Click en "Limpiar datos"
5. Cierra el navegador completamente
6. Abre en incógnito y ve a la URL

---

## 🎯 LO QUE DEBERÍAS VER:

Cuando el caché esté limpio, verás:

```
┌─────────────────────────────────────────────┐
│ 🔵 P  PETCIMAGENES                         │ ← Header azul
│       Asistente Inteligente                 │
└─────────────────────────────────────────────┘
┌─────────────────┬───────────────────────────┐
│                 │                           │
│ 📎 Subir        │                           │
│ Archivos        │      Chat Area            │
│ (Máx. 10)       │                           │
│ ─────────       │                           │
│                 │                           │
│ 📁 No hay       │                           │
│ archivos        │                           │
│ subidos         │                           │
│                 │                           │
└─────────────────┴───────────────────────────┘
         ↑
    Este botón debe
    estar VERDE
```

---

## 📤 CÓMO USAR EL BOTÓN DE ARCHIVOS:

### 1. Subir Archivos
- Click en "📎 Subir Archivos (Máx. 10)"
- Selecciona hasta 10 archivos
- Soporta: PDF, DOCX, XLSX, CSV, TXT, PNG, JPG
- Máximo 10 MB por archivo

### 2. Ver Archivos Subidos
Los archivos aparecerán en la lista con:
- Icono del tipo de archivo (PDF, XLSX, etc.)
- Nombre del archivo
- Tamaño del archivo

### 3. Consultar sobre los Archivos
Después de subir, puedes preguntar:
```
"¿Qué documentos tengo disponibles?"
"Analiza el documento PDF que subí"
"Resume el contenido de los archivos"
"¿Qué dice el organigrama sobre el área de Radiología?"
```

---

## 🔍 VERIFICACIÓN:

### Backend tiene el endpoint correcto:
```bash
curl -X POST https://rosia-unbrocaded-distinguishedly.ngrok-free.dev/api/upload \
  -F "files=@test.txt"
```

Debe responder:
```json
{
  "success": true,
  "message": "1 archivo(s) subido(s) correctamente al vector store",
  "files": [...]
}
```

### Frontend tiene el código:
El archivo `frontend/index.html` ya tiene:
- Botón verde de upload ✅
- Input de archivos oculto ✅
- Función `handleFileUpload()` ✅
- Lista de archivos ✅
- Integración con `/api/upload` ✅

---

## 🐛 SI AÚN NO VES EL BOTÓN:

### 1. Verificar que el HTML se está sirviendo:
```bash
curl -s https://rosia-unbrocaded-distinguishedly.ngrok-free.dev | grep -i "subir archivos"
```

Debe mostrar: `📎 Subir Archivos (Máx. 10)`

### 2. Ver en DevTools qué HTML está cargando:
1. Abre la app
2. Presiona F12 (DevTools)
3. Ve a la pestaña "Elements"
4. Busca (Cmd+F): "Subir Archivos"
5. Debe aparecer el botón

### 3. Reiniciar el backend:
```bash
# Detener backend
lsof -ti:3000 | xargs kill -9

# Reiniciar
cd /Users/hbva/AgentkitV1
./INICIAR_BACKEND_CORRECTO.sh
```

---

## 📊 FLUJO COMPLETO:

```
1. Usuario click en "📎 Subir Archivos"
   ↓
2. Selecciona archivos del sistema
   ↓
3. Frontend: Muestra archivos en la lista
   ↓
4. Frontend: POST /api/upload con FormData
   ↓
5. Backend: Recibe archivos
   ↓
6. Backend: Sube a OpenAI Files API
   ↓
7. Backend: Agrega al Vector Store
   ↓
8. Backend: Responde con IDs de archivos
   ↓
9. Frontend: Muestra "✅ X archivo(s) subido(s)"
   ↓
10. Usuario puede hacer preguntas sobre los archivos
```

---

## ✅ CHECKLIST:

- [ ] Backend corriendo en puerto 3000
- [ ] Ngrok activo con dominio aprobado
- [ ] Navegador en modo incógnito
- [ ] Caché limpiado
- [ ] Página recargada con Cmd+Shift+R
- [ ] Ves el header azul de PETCIMAGENES
- [ ] Ves el sidebar blanco a la izquierda
- [ ] Ves el botón verde "Subir Archivos"

---

**¿Ya limpiaste el caché y reintentaste?** El botón definitivamente está en el código! 🚀
