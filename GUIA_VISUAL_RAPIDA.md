# 🎨 GUÍA VISUAL RÁPIDA - PETCIMAGENES Agent

## 🚀 ARRANQUE RÁPIDO (3 PASOS)

```
╔════════════════════════════════════════════╗
║  TERMINAL 1: Backend                       ║
╚════════════════════════════════════════════╝
   $ cd /Users/hbva/AgentkitV1
   $ ./INICIAR_BACKEND_CORRECTO.sh
   
   ✅ Backend iniciado en puerto 3000


╔════════════════════════════════════════════╗
║  TERMINAL 2: Ngrok                         ║
╚════════════════════════════════════════════╝
   $ ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev
   
   ✅ Forwarding activo


╔════════════════════════════════════════════╗
║  NAVEGADOR: Frontend (Incógnito)           ║
╚════════════════════════════════════════════╝
   https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
   
   ✅ Interfaz cargada
```

---

## 🖥️ INTERFAZ DEL SISTEMA

```
┌───────────────────────────────────────────────────────────────────┐
│  PETCIMAGENES - Asistente AI                                      │
└───────────────────────────────────────────────────────────────────┘

┌─────────────────┬─────────────────────────────────────────────────┐
│                 │                                                 │
│  SIDEBAR        │            ÁREA DE CHAT                         │
│  (Vector Store) │                                                 │
│                 │  ┌─────────────────────────────────────────┐   │
│  📂 Seleccionar │  │  TÚ: Hola, preséntate                   │   │
│     Archivos    │  └─────────────────────────────────────────┘   │
│                 │                                                 │
│  📄 archivo1.pdf│  ┌─────────────────────────────────────────┐   │
│  📊 datos.xlsx  │  │  AI: Soy el Analista Estratégico...     │   │
│  📄 manual.pdf  │  └─────────────────────────────────────────┘   │
│                 │                                                 │
│  ⬆️ Enviar al   │  ┌───────────────────────────────────────┐     │
│    Vector Store │  │  📎 archivo.pdf (2.3 MB)              │     │
│                 │  ├───────────────────────────────────────┤     │
│                 │  │  Escribe tu mensaje...                │     │
│                 │  │  [📎] [Enviar]                        │     │
│                 │  └───────────────────────────────────────┘     │
└─────────────────┴─────────────────────────────────────────────────┘
```

---

## 📂 DOS SISTEMAS DE ARCHIVOS

### Sistema 1: ATTACHMENTS TEMPORALES (Chat)

```
        Usuario
           │
           │ Click 📎
           ▼
    ┌──────────────┐
    │ Selecciona   │
    │ archivo(s)   │
    └──────────────┘
           │
           │ Preview
           ▼
    ┌──────────────┐
    │ 📎 datos.xlsx│
    │ (1.2 MB)     │
    └──────────────┘
           │
           │ Escribe + Envía
           ▼
    ┌──────────────────────┐
    │ Backend procesa      │
    │ Sube a OpenAI        │
    │ Genera file_id       │
    └──────────────────────┘
           │
           │ Pasa al Agent
           ▼
    ┌──────────────────────┐
    │ Agent analiza        │
    │ → Responde           │
    └──────────────────────┘
           │
           │ Después del mensaje
           ▼
    ┌──────────────────────┐
    │ Archivo desaparece   │
    │ (No queda guardado)  │
    └──────────────────────┘

📍 USO: Análisis puntual de datos
📍 EJEMPLOS: 
   - Analizar Excel del mes
   - Revisar un PDF específico
   - Procesar imagen
```

### Sistema 2: VECTOR STORE PERMANENTE (Sidebar)

```
        Usuario
           │
           │ Click 📂 Seleccionar
           ▼
    ┌──────────────┐
    │ Selecciona   │
    │ documento(s) │
    └──────────────┘
           │
           │ Aparece en lista
           ▼
    ┌──────────────┐
    │ 📄 manual.pdf│
    │ 📊 hist.xlsx │
    └──────────────┘
           │
           │ Click ⬆️ Enviar
           ▼
    ┌──────────────────────┐
    │ Backend procesa      │
    │ Sube a OpenAI        │
    │ Agrega a Vector Store│
    └──────────────────────┘
           │
           │ PERMANENTE
           ▼
    ┌──────────────────────┐
    │ Queda en Vector Store│
    │ Accesible siempre    │
    └──────────────────────┘
           │
           │ En cualquier pregunta
           ▼
    ┌──────────────────────┐
    │ Agent usa file_search│
    │ Encuentra info       │
    │ Responde citando     │
    └──────────────────────┘

📍 USO: Base de conocimiento corporativa
📍 EJEMPLOS:
   - Manuales de equipos
   - Políticas internas
   - Datos históricos
   - Informes anuales
```

---

## 🔄 FLUJO DE UN MENSAJE CON ARCHIVO

```
┌─────────────────────────────────────────────────────────────┐
│  1. USUARIO                                                 │
│     ↓                                                       │
│     Click 📎 → Selecciona archivo → Preview               │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  2. FRONTEND                                                │
│     ↓                                                       │
│     Crea FormData:                                          │
│     - message: "Analiza esto"                               │
│     - files: [File Object]                                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
                 POST /api/chat/stream
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  3. BACKEND: Multer                                         │
│     ↓                                                       │
│     Recibe archivo → Guarda en /uploads                     │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  4. BACKEND: fileUpload.js                                  │
│     ↓                                                       │
│     uploadFilesToOpenAI()                                   │
│     - Crea ReadStream                                       │
│     - Sube a OpenAI                                         │
│     - Obtiene: file-abc123                                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  5. BACKEND: chatController.js                              │
│     ↓                                                       │
│     fileIds = ["file-abc123"]                               │
│     agentService.executeWorkflowStream(msg, ctx, fileIds)   │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  6. BACKEND: agentService.js  ⭐ FIX AQUÍ                   │
│     ↓                                                       │
│     userContent = [                                         │
│       { type: "input_text", text: msg },                    │
│       { type: "input_file", file_id: "file-abc123" } ←──┐   │
│     ]                                                    │   │
│                                              CLAVE DEL FIX   │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  7. OpenAI Agent SDK                                        │
│     ↓                                                       │
│     Procesa mensaje + archivo                               │
│     Usa herramientas (file_search, code_interpreter...)     │
│     Genera respuesta                                        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  8. BACKEND: Streaming                                      │
│     ↓                                                       │
│     for await (const event of stream) {                     │
│       res.write(`data: ${event}\n\n`)                       │
│     }                                                       │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  9. FRONTEND: EventSource                                   │
│     ↓                                                       │
│     Recibe tokens → Muestra en tiempo real                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│  10. USUARIO                                                │
│      ↓                                                      │
│      Ve respuesta aparecer palabra por palabra              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 CASOS DE USO VISUALES

### Caso 1: Análisis de Ventas Mensuales

```
┌───────────────────────────────────┐
│ 1. Usuario tiene Excel de ventas │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 2. Click 📎 → ventas_oct.xlsx     │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 3. Escribe: "¿Producto top?"      │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 4. Agent analiza Excel            │
│    → Responde con producto #1     │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 5. Archivo desaparece (temporal)  │
└───────────────────────────────────┘

✅ Perfecto para datos que cambian cada mes
```

### Caso 2: Base de Conocimiento Permanente

```
┌───────────────────────────────────┐
│ 1. Empresa tiene manuales         │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 2. Sidebar → 📂 Seleccionar       │
│    manual_petct.pdf               │
│    manual_rm.pdf                  │
│    protocolos.pdf                 │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 3. ⬆️ Enviar al Vector Store       │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 4. Archivos quedan permanentes    │
└───────────────────────────────────┘
              ↓
┌───────────────────────────────────┐
│ 5. SIEMPRE disponibles            │
│    "¿Cómo calibrar PET-CT?"       │
│    → Agent busca en manual        │
│    → Responde con pasos exactos   │
└───────────────────────────────────┘

✅ Perfecto para conocimiento corporativo estable
```

### Caso 3: Análisis Comparativo

```
┌────────────────────────────────────┐
│ PREPARACIÓN                        │
│ ↓                                  │
│ Subir datos históricos al          │
│ Vector Store (una vez)             │
│ → informe_2024.pdf                 │
└────────────────────────────────────┘
              ↓
┌────────────────────────────────────┐
│ USO DIARIO                         │
│ ↓                                  │
│ 1. Click 📎 → datos_hoy.xlsx       │
│ 2. Pregunta: "Compara con 2024"   │
└────────────────────────────────────┘
              ↓
┌────────────────────────────────────┐
│ RESULTADO                          │
│ ↓                                  │
│ Agent usa:                         │
│ - Archivo temporal (xlsx de hoy)   │
│ - Vector Store (PDF histórico)     │
│ → Respuesta comparativa completa   │
└────────────────────────────────────┘

✅ Combina lo mejor de ambos sistemas
```

---

## 🔍 VERIFICACIÓN VISUAL

### ✅ Sistema Funcionando Correctamente

```
BACKEND (Terminal 1):
┌────────────────────────────────────┐
│ 🚀 Backend en puerto 3000          │
│ [INFO] Subiendo 1 archivo(s)       │
│ [INFO] Archivo subido: file-abc... │
│ [INFO] Agregando 1 archivo como... │
│ [DEBUG] Ejecutando agent workflow  │
└────────────────────────────────────┘
           👍 TODO OK

NGROK (Terminal 2):
┌────────────────────────────────────┐
│ Forwarding                         │
│ https://rosia-unbro...             │
│ Status: online                     │
└────────────────────────────────────┘
           👍 TODO OK

NAVEGADOR:
┌────────────────────────────────────┐
│ PETCIMAGENES                       │
│ ├─ Sidebar visible                 │
│ ├─ Chat funcionando                │
│ ├─ Botón 📎 activo                 │
│ └─ Sin errores en consola (F12)    │
└────────────────────────────────────┘
           👍 TODO OK
```

### ❌ Problemas Comunes

```
PROBLEMA: Backend no inicia
┌────────────────────────────────────┐
│ ❌ Error: Cannot find module...    │
└────────────────────────────────────┘
SOLUCIÓN:
    $ cd backend
    $ npm install


PROBLEMA: Archivos no se procesan
┌────────────────────────────────────┐
│ ❌ Agent no menciona el archivo    │
└────────────────────────────────────┘
VERIFICAR LOGS:
    $ tail -f logs/backend.log
    
DEBE MOSTRAR:
    [INFO] Agregando X archivo(s)...
    
SI NO APARECE → Revisar .env


PROBLEMA: Frontend no carga
┌────────────────────────────────────┐
│ ❌ Cannot connect                  │
└────────────────────────────────────┘
VERIFICAR:
    1. Backend corriendo? → ps aux | grep node
    2. Ngrok activo? → Terminal 2
    3. URL correcta? → Incógnito
```

---

## 📊 DASHBOARD DE ESTADO

```
╔═══════════════════════════════════════════════════════════╗
║  COMPONENTE          │  ESTADO  │  NOTAS                 ║
╠═══════════════════════════════════════════════════════════╣
║  Backend             │    ✅    │  Puerto 3000           ║
║  Frontend            │    ✅    │  Dual system           ║
║  Chat Básico         │    ✅    │  Streaming OK          ║
║  Attachments         │    ✅    │  Procesamiento OK      ║
║  Vector Store        │    ✅    │  vs_68f470...          ║
║  File Search         │    ✅    │  Búsqueda OK           ║
║  Web Search          │    ✅    │  Integrado             ║
║  Code Interpreter    │    ✅    │  Python OK             ║
╠═══════════════════════════════════════════════════════════╣
║  ESTADO GENERAL      │   100%   │  🎉 FUNCIONAL          ║
╚═══════════════════════════════════════════════════════════╝
```

---

## 🎓 TIPS RÁPIDOS

```
💡 TIP 1: Usar modo incógnito
   → Evita problemas de caché

💡 TIP 2: Vector Store para conocimiento estable
   → Manuales, políticas, históricos

💡 TIP 3: Attachments para análisis puntual
   → Datos del día, reportes temporales

💡 TIP 4: Verificar logs si algo falla
   → tail -f logs/backend.log

💡 TIP 5: Combinar ambos sistemas
   → Contexto permanente + datos actuales
```

---

## 📚 SIGUIENTE PASO

```
┌─────────────────────────────────────────┐
│  QUIERO EMPEZAR A USAR EL SISTEMA       │
│  → Lee: INICIO_RAPIDO.md                │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  QUIERO ENTENDER LA ARQUITECTURA        │
│  → Lee: PROYECTO_COMPLETADO.md          │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  TENGO UN PROBLEMA                      │
│  → Lee: SOLUCION_ARCHIVOS_COMPLETA.md   │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│  QUIERO VER TODA LA DOCUMENTACIÓN       │
│  → Lee: INDICE_MAESTRO.md               │
└─────────────────────────────────────────┘
```

---

**🎨 Fin de la Guía Visual**

**Última actualización:** 23 de octubre, 2025  
**Versión:** 2.0  
**Estado:** ✅ 100% Funcional
