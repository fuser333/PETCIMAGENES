# 🤖 PETCIMAGENES AI Agent

**Agente de IA Estratégico para Análisis Corporativo**

[![Estado](https://img.shields.io/badge/Estado-100%25%20Funcional-brightgreen)]()
[![Versión](https://img.shields.io/badge/Versión-2.0-blue)]()
[![Backend](https://img.shields.io/badge/Backend-Express.js-green)]()
[![AI](https://img.shields.io/badge/AI-GPT--4o-orange)]()

---

## 🎯 Descripción

Sistema de agente inteligente para PETCIMAGENES que proporciona análisis estratégicos, procesa documentos corporativos y responde preguntas basadas en la base de conocimiento interna y fuentes externas.

**Capacidades principales:**
- 💬 Chat conversacional con streaming en tiempo real
- 📄 Procesamiento de documentos (PDF, Excel, Word, imágenes)
- 🗄️ Base de conocimiento persistente (Vector Store)
- 🔍 Búsqueda en documentos internos
- 🌐 Búsquedas web para información actual
- 💻 Ejecución de código Python para análisis

---

## ⚡ Inicio Rápido

### Requisitos Previos
- Node.js v18+
- Cuenta OpenAI con API key
- Ngrok (para exposición pública)

### Instalación en 3 Pasos

**1. Clonar e instalar dependencias**
```bash
cd /Users/hbva/AgentkitV1/backend
npm install
```

**2. Configurar variables de entorno**
```bash
# Crear archivo .env
cp .env.example .env

# Editar con tus credenciales
nano .env
```

**3. Iniciar el sistema**
```bash
# Terminal 1: Backend
./INICIAR_BACKEND_CORRECTO.sh

# Terminal 2: Ngrok
ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev

# Navegador (incógnito recomendado)
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

---

## 📖 Documentación

### Para Usuarios
- 📘 **[INICIO_RAPIDO.md](INICIO_RAPIDO.md)** - Guía de usuario (5 min)
- ✅ **[CHECKLIST_VERIFICACION_COMPLETA.md](CHECKLIST_VERIFICACION_COMPLETA.md)** - Verificar instalación

### Para Desarrolladores
- 📗 **[PROYECTO_COMPLETADO.md](PROYECTO_COMPLETADO.md)** - Documentación técnica
- 🔧 **[SOLUCION_ARCHIVOS_COMPLETA.md](SOLUCION_ARCHIVOS_COMPLETA.md)** - Arquitectura y troubleshooting

### Índice General
- 📚 **[INDICE_MAESTRO.md](INDICE_MAESTRO.md)** - Navegación completa de docs

---

## 🛠️ Tecnologías

### Backend
- **Framework:** Express.js
- **AI SDK:** OpenAI Agents SDK v2
- **Model:** GPT-4o
- **File Upload:** Multer
- **Streaming:** Server-Sent Events (SSE)
- **Logging:** Winston

### Frontend
- **Stack:** HTML5 + Vanilla JavaScript + CSS3
- **Streaming:** EventSource API
- **Upload:** FormData API
- **Design:** Colores corporativos PETCIMAGENES

### Infraestructura
- **Tunneling:** Ngrok
- **Vector Store:** OpenAI Vector Store
- **Port:** 3000 (configurable)

---

## 📁 Estructura del Proyecto

```
AgentkitV1/
├── backend/
│   ├── src/
│   │   ├── controllers/        # Controladores de endpoints
│   │   ├── services/           # Lógica de negocio
│   │   │   └── agentService.js # ⭐ Core del agente
│   │   ├── routes/             # Rutas de la API
│   │   ├── utils/              # Utilidades
│   │   └── config/             # Configuración
│   ├── uploads/                # Archivos temporales
│   ├── .env                    # Variables de entorno
│   └── package.json
├── frontend/
│   └── index.html              # Interfaz del usuario
├── logs/
│   └── backend.log             # Logs del sistema
└── docs/                       # Documentación completa
```

---

## 🎮 Uso del Sistema

### Sistema Dual de Archivos

#### 📎 Attachments Temporales (Chat)
Para análisis puntuales de archivos:

1. Click en botón **📎** en el chat
2. Selecciona archivo(s)
3. Escribe tu pregunta
4. Enviar

**Ejemplo:**
```
Adjunta: ventas_octubre.xlsx
Pregunta: "¿Cuál fue el producto más vendido?"
```

#### 🗄️ Vector Store Permanente (Sidebar)
Para conocimiento corporativo persistente:

1. En sidebar: **📂 Seleccionar Archivos**
2. Selecciona documento(s)
3. Click **⬆️ Enviar al Vector Store**
4. El agente lo recordará siempre

**Ejemplo:**
```
Sube: manual_equipos.pdf
Luego pregunta: "¿Cómo calibrar el PET-CT?"
→ El agente busca automáticamente en el manual
```

---

## 🔧 Configuración

### Variables de Entorno (.env)

```env
# OpenAI
OPENAI_API_KEY=sk-proj-...                    # Tu API key
VECTOR_STORE_ID=vs_68f4701fe6c881918246...   # ID del vector store

# Server
PORT=3000                                     # Puerto del backend
NODE_ENV=development                          # Ambiente

# Logging
LOG_LEVEL=info                                # Nivel de logs
```

### Endpoints de la API

```
POST   /api/chat/stream          # Chat con streaming
POST   /api/files/upload         # Subir al vector store
GET    /api/health               # Health check
```

---

## 🧪 Testing

### Test Manual Rápido
```bash
# 1. Iniciar sistema (ver Inicio Rápido)

# 2. En el navegador:
- Escribe: "Hola, preséntate"
- Debe responder como Analista de PETCIMAGENES

# 3. Adjunta un archivo y pregunta sobre él
- Debe analizar y responder con detalles específicos
```

### Test Automatizado
```bash
cd /Users/hbva/AgentkitV1
./TEST_SISTEMA.sh
```

### Verificar Logs
```bash
tail -f /Users/hbva/AgentkitV1/logs/backend.log
```

**Logs esperados al subir archivos:**
```
[INFO] Subiendo 1 archivo(s)
[INFO] Archivo subido: file-xxxxx - archivo.pdf
[INFO] Agregando 1 archivo(s) al mensaje como attachments
```

---

## 🐛 Troubleshooting

### Backend no inicia
```bash
cd backend
npm install
node src/server.js
```

### Archivos no se procesan
1. Verificar logs: `tail -f logs/backend.log`
2. Debe mostrar: `Agregando X archivo(s) como attachments`
3. Si no aparece, revisar .env

### Frontend no conecta
1. Verificar que backend esté corriendo: `curl http://localhost:3000/api/health`
2. Verificar ngrok: debe mostrar "Forwarding"
3. Usar modo incógnito para evitar caché

**Para más detalles:** Ver [SOLUCION_ARCHIVOS_COMPLETA.md](SOLUCION_ARCHIVOS_COMPLETA.md)

---

## 📊 Estado del Proyecto

| Componente | Estado | Notas |
|------------|--------|-------|
| Backend | ✅ Funcional | Express + Agents SDK |
| Frontend | ✅ Funcional | Dual system implementado |
| Chat Básico | ✅ Funcional | Streaming perfecto |
| Attachments | ✅ Funcional | Procesamiento correcto |
| Vector Store | ✅ Funcional | Conocimiento persistente |
| File Search | ✅ Funcional | Búsqueda en documentos |
| Web Search | ✅ Funcional | Búsquedas externas |
| Code Interpreter | ✅ Funcional | Ejecución de Python |

---

## 🎯 Roadmap

### ✅ Completado (v2.0)
- [x] Chat con streaming
- [x] Procesamiento de archivos (todos los tipos)
- [x] Vector store integrado
- [x] Sistema dual de archivos
- [x] Documentación completa

### 🔮 Futuras Mejoras (Opcional)
- [ ] Historial de conversaciones
- [ ] Export a PDF
- [ ] Drag & drop de archivos
- [ ] Preview de PDFs
- [ ] Multi-idioma

---

## 👥 Equipo

**Desarrollado para:** PETCIMAGENES  
**Objetivo:** Análisis estratégico corporativo con IA  

---

## 📄 Licencia

Proyecto privado - PETCIMAGENES

---

## 🆘 Soporte

### Documentación Disponible
1. **INDICE_MAESTRO.md** - Navegación completa
2. **INICIO_RAPIDO.md** - Guía de usuario
3. **PROYECTO_COMPLETADO.md** - Docs técnicas
4. **SOLUCION_ARCHIVOS_COMPLETA.md** - Troubleshooting

### Recursos Externos
- [OpenAI Agents SDK](https://platform.openai.com/docs/agents)
- [Express.js Docs](https://expressjs.com)
- [Ngrok Docs](https://ngrok.com/docs)

---

## 🎉 Agradecimientos

Proyecto desarrollado usando:
- OpenAI Agents SDK v2
- GPT-4o
- Express.js
- Multer

**Versión:** 2.0  
**Última actualización:** 23 de octubre, 2025  
**Estado:** ✅ Production Ready

---

<div align="center">

**[⬆ Volver arriba](#-petcimagenes-ai-agent)**

---

**🚀 ¡El sistema está listo para usar! 🚀**

</div>
