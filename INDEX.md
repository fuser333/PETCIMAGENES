# 📚 ÍNDICE DE DOCUMENTACIÓN - PETCIMAGENES AI

## 🎯 INICIO RÁPIDO

### Si es tu primera vez:
1. Lee → [README.md](README.md)
2. Ejecuta → `./QUICKSTART.sh`
3. Abre la URL en incógnito

### Si ya conoces el proyecto:
```bash
./INICIAR_NGROK.sh
```

---

## 📖 DOCUMENTACIÓN DISPONIBLE

### 🚀 Para Empezar
| Documento | Descripción | Cuándo Usarlo |
|-----------|-------------|---------------|
| [README.md](README.md) | Overview completo del proyecto | Primera lectura obligatoria |
| [QUICKSTART.sh](QUICKSTART.sh) | Script con validaciones automáticas | Inicio rápido con verificaciones |
| [INICIAR_NGROK.sh](INICIAR_NGROK.sh) | Script de inicio con ngrok | Inicio estándar del sistema |

### 📘 Guías Detalladas
| Documento | Descripción | Cuándo Usarlo |
|-----------|-------------|---------------|
| [GUIA_COMPLETA.md](GUIA_COMPLETA.md) | Tutorial paso a paso exhaustivo | Cuando necesites entender cada parte |
| [CHECKLIST_VERIFICACION.md](CHECKLIST_VERIFICACION.md) | Lista de verificación técnica | Después de cambios o para QA |
| [RESUMEN_SESION.md](RESUMEN_SESION.md) | Resumen ejecutivo de configuración | Para recordar qué se hizo |

### 🔧 Soporte Técnico
| Documento | Descripción | Cuándo Usarlo |
|-----------|-------------|---------------|
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Solución de problemas comunes | Cuando algo no funciona |
| logs/backend.log | Logs del servidor | Debug de errores del backend |
| logs/ngrok.log | Logs de ngrok | Debug de tunneling/networking |

---

## 🗂️ ESTRUCTURA DE ARCHIVOS

### 📁 Nivel Raíz
```
/Users/hbva/AgentkitV1/
├── 📄 README.md                      ← Empieza aquí
├── 📄 INDEX.md                       ← Este archivo
├── 📄 GUIA_COMPLETA.md              ← Guía detallada
├── 📄 CHECKLIST_VERIFICACION.md     ← Verificación técnica
├── 📄 TROUBLESHOOTING.md            ← Solución de problemas
├── 📄 RESUMEN_SESION.md             ← Resumen ejecutivo
├── 🚀 QUICKSTART.sh                 ← Inicio con validaciones
├── 🚀 INICIAR_NGROK.sh              ← Inicio estándar
├── 📁 backend/                      ← Servidor Node.js
├── 📁 frontend/                     ← Interfaz web
└── 📁 logs/                         ← Logs del sistema
```

### 📁 Backend (`backend/`)
```
backend/
├── src/
│   ├── app.js                       ← Configuración Express
│   ├── controllers/
│   │   └── chatController.js        ← Lógica chat + uploads
│   ├── routes/
│   │   └── chatRoutes.js            ← Endpoints API
│   ├── services/
│   │   └── agentService.js          ← GPT-4o + Vector Store
│   ├── utils/
│   │   └── fileUpload.js            ← Gestión archivos
│   ├── config/                      ← Configuraciones
│   └── middleware/                  ← Middlewares Express
├── package.json                     ← Dependencias npm
└── .env                             ← Variables de entorno ⚠️
```

### 📁 Frontend (`frontend/`)
```
frontend/
└── index.html                       ← Interfaz completa (19KB)
```

---

## 🎓 RUTAS DE APRENDIZAJE

### 👤 Para Usuarios (No Técnicos)
1. [README.md](README.md) - Sección "Quick Start"
2. [GUIA_COMPLETA.md](GUIA_COMPLETA.md) - Sección "Cómo Usar el Chat"
3. Ejecutar `./QUICKSTART.sh`
4. Abrir URL en incógnito

### 👨‍💻 Para Desarrolladores
1. [README.md](README.md) - Completo
2. [GUIA_COMPLETA.md](GUIA_COMPLETA.md) - Completa
3. [CHECKLIST_VERIFICACION.md](CHECKLIST_VERIFICACION.md) - Verificar setup
4. Revisar código en `backend/src/`

### 🔧 Para DevOps/SysAdmin
1. [README.md](README.md) - Sección "Deployment"
2. [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Completo
3. Revisar `.env` y configuración
4. Monitorear `logs/`

---

## 🚨 CASOS DE EMERGENCIA

### 🔥 El sistema no inicia
1. Lee → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Ejecuta el "Reseteo Completo"
3. Verifica logs: `tail -f logs/backend.log`

### 🔥 El diseño no se carga
1. Abre en **modo incógnito**
2. Presiona `Cmd + Shift + R`
3. Si persiste → [TROUBLESHOOTING.md](TROUBLESHOOTING.md) sección 1

### 🔥 Los archivos no se suben
1. Verifica [TROUBLESHOOTING.md](TROUBLESHOOTING.md) sección 4
2. Revisa logs: `tail -f logs/backend.log`
3. Verifica `.env` tiene `VECTOR_STORE_ID`

---

## 📊 DIAGRAMAS DE FLUJO

### Flujo de Inicio
```
Usuario ejecuta QUICKSTART.sh
    ↓
Verifica Node.js, npm, ngrok
    ↓
Verifica .env y dependencias
    ↓
Inicia backend en :3000
    ↓
Inicia ngrok tunnel
    ↓
Muestra URL pública
    ↓
Usuario abre en incógnito
```

### Flujo de Upload
```
Usuario selecciona archivos
    ↓
Frontend: POST /api/upload
    ↓
Backend: Recibe archivos
    ↓
Sube a OpenAI Files
    ↓
Agrega a Vector Store
    ↓
Responde con IDs
    ↓
Frontend muestra confirmación
```

### Flujo de Chat
```
Usuario escribe mensaje
    ↓
Frontend: POST /api/chat/stream
    ↓
Backend: Crea conversación
    ↓
OpenAI GPT-4o procesa
    ↓
Busca en Vector Store (si aplica)
    ↓
Stream tokens de respuesta
    ↓
Frontend muestra token por token
```

---

## 🔍 BÚSQUEDA RÁPIDA

### "¿Cómo...?"
- **...inicio el sistema?** → [README.md](README.md) "Quick Start" o ejecuta `./QUICKSTART.sh`
- **...subo archivos?** → [GUIA_COMPLETA.md](GUIA_COMPLETA.md) "Subir Archivos"
- **...soluciono problemas?** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **...cambio colores?** → [README.md](README.md) "Personalización"
- **...veo logs?** → `tail -f logs/backend.log`
- **...reinicio todo?** → [TROUBLESHOOTING.md](TROUBLESHOOTING.md) "Reseteo Completo"

### "¿Qué es...?"
- **...GPT-4o?** → [GUIA_COMPLETA.md](GUIA_COMPLETA.md) "Configuración Técnica"
- **...Vector Store?** → [GUIA_COMPLETA.md](GUIA_COMPLETA.md) "Subir Archivos"
- **...Streaming?** → [README.md](README.md) "Características"
- **...ngrok?** → [GUIA_COMPLETA.md](GUIA_COMPLETA.md) "Cómo Acceder"

### "¿Dónde está...?"
- **...el código del backend?** → `backend/src/`
- **...el frontend?** → `frontend/index.html`
- **...la configuración?** → `backend/.env`
- **...los logs?** → `logs/`
- **...la API key?** → `backend/.env` (OPENAI_API_KEY)

---

## ⚙️ COMANDOS FRECUENTES

```bash
# Iniciar sistema
./QUICKSTART.sh

# Ver logs en tiempo real
tail -f logs/backend.log

# Health check
curl http://localhost:3000/health

# Matar procesos
lsof -ti:3000 | xargs kill -9
killall ngrok

# Reinstalar dependencias
cd backend && rm -rf node_modules && npm install

# Ver procesos corriendo
ps aux | grep node
ps aux | grep ngrok

# Abrir en navegador
open http://localhost:3000
```

---

## 📞 CONTACTOS Y RECURSOS

### Documentación Oficial
- **OpenAI Agents SDK:** https://platform.openai.com/docs/agents
- **OpenAI API:** https://platform.openai.com/docs/api-reference
- **Express.js:** https://expressjs.com/
- **ngrok:** https://ngrok.com/docs

### Plataformas
- **OpenAI Platform:** https://platform.openai.com/
- **Vector Stores:** https://platform.openai.com/storage/vector_stores
- **API Keys:** https://platform.openai.com/api-keys

---

## ✅ CHECKLIST DE INICIO

Antes de empezar, verifica:
- [ ] Node.js v18+ instalado
- [ ] npm instalado
- [ ] ngrok instalado
- [ ] `backend/.env` configurado
- [ ] OPENAI_API_KEY válida
- [ ] VECTOR_STORE_ID correcto
- [ ] Puerto 3000 disponible

Luego ejecuta:
```bash
./QUICKSTART.sh
```

---

## 🎯 PRÓXIMOS PASOS

1. **Hoy:** Ejecuta `./QUICKSTART.sh` y prueba el sistema
2. **Esta semana:** Sube documentos de PETCIMAGENES al Vector Store
3. **Próxima semana:** Personaliza prompts del agente
4. **Mes siguiente:** Evalúa deployment en producción

---

**💡 TIP:** Guarda este INDEX.md en favoritos. Es tu mapa del proyecto.

**Última actualización:** Octubre 2025  
**Versión de la documentación:** 1.0
