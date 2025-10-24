# 🎯 PETCIMAGENES AI Assistant

Sistema completo de asistente inteligente para PETCIMAGENES con integración OpenAI GPT-4o, gestión de documentos en Vector Store, y chat en tiempo real con streaming.

---

## ✨ Características Principales

### 🤖 Inteligencia Artificial
- **GPT-4o** - Modelo más rápido y eficiente
- **File Search** - Búsqueda en documentos internos del Vector Store
- **Web Search** - Información actualizada de internet
- **Code Interpreter** - Análisis de datos y cálculos complejos
- **Streaming** - Respuestas token por token en tiempo real

### 🎨 Interfaz de Usuario
- **Diseño Corporativo** - Colores PETCIMAGENES (#284A89, #9DD43B)
- **Responsive** - Adaptado para desktop, tablet y móvil
- **Upload de Archivos** - Hasta 10 archivos simultáneos
- **Chat Moderno** - Avatares, animaciones y UX optimizada

### 🔧 Tecnologías
- **Backend:** Node.js + Express
- **Frontend:** HTML5 + CSS3 + JavaScript (Vanilla)
- **AI:** OpenAI GPT-4o + Agent SDK
- **Storage:** Vector Store para documentos
- **Deployment:** ngrok para desarrollo

---

## 🚀 Quick Start

### 1. Requisitos Previos
```bash
# Verificar Node.js (v18+)
node --version

# Verificar npm
npm --version

# Instalar ngrok (si no lo tienes)
brew install ngrok
```

### 2. Iniciar el Sistema
```bash
cd /Users/hbva/AgentkitV1
./QUICKSTART.sh
```

### 3. Acceder a la Aplicación
El script te dará una URL como:
```
https://xxxx-xxxx.ngrok-free.app
```

**IMPORTANTE:** Abre siempre en modo incógnito para evitar problemas de caché.

---

## 📁 Estructura del Proyecto

```
/Users/hbva/AgentkitV1/
├── backend/                          # Servidor Node.js
│   ├── src/
│   │   ├── app.js                    # Configuración Express
│   │   ├── controllers/
│   │   │   └── chatController.js     # Lógica del chat + uploads
│   │   ├── routes/
│   │   │   └── chatRoutes.js         # Endpoints API
│   │   ├── services/
│   │   │   └── agentService.js       # Integración OpenAI GPT-4o
│   │   ├── utils/
│   │   │   └── fileUpload.js         # Gestión de archivos
│   │   ├── config/
│   │   └── middleware/
│   ├── package.json
│   └── .env                          # Variables de entorno
├── frontend/
│   └── index.html                    # Interfaz completa
├── logs/                             # Logs del sistema
├── INICIAR_NGROK.sh                  # Script de inicio con ngrok
├── QUICKSTART.sh                     # Script rápido con validaciones
├── GUIA_COMPLETA.md                  # Documentación exhaustiva
├── CHECKLIST_VERIFICACION.md         # Lista de verificación técnica
├── TROUBLESHOOTING.md                # Solución de problemas
├── RESUMEN_SESION.md                 # Resumen ejecutivo
└── README.md                         # Este archivo
```

---

## 🔐 Variables de Entorno

Crea/edita el archivo `backend/.env`:

```bash
PORT=3000
NODE_ENV=development
OPENAI_API_KEY=sk-proj-...
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
WORKFLOW_ID=wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8
```

---

## 📡 Endpoints de la API

### GET /
Sirve el frontend HTML

### GET /health
Health check del servidor
```bash
curl http://localhost:3000/health
```

### POST /api/upload
Sube archivos al Vector Store (máx. 10 archivos, 10 MB c/u)
```bash
curl -X POST http://localhost:3000/api/upload \
  -F "files=@documento.pdf"
```

### POST /api/chat/stream
Chat con streaming en tiempo real
```bash
curl -X POST http://localhost:3000/api/chat/stream \
  -H "Content-Type: application/json" \
  -d '{"message":"Analiza el organigrama"}'
```

---

## 📚 Documentación Completa

| Documento | Descripción |
|-----------|-------------|
| [GUIA_COMPLETA.md](GUIA_COMPLETA.md) | Guía paso a paso exhaustiva |
| [CHECKLIST_VERIFICACION.md](CHECKLIST_VERIFICACION.md) | Lista de verificación técnica |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Solución de problemas comunes |
| [RESUMEN_SESION.md](RESUMEN_SESION.md) | Resumen ejecutivo de la configuración |

---

## 🎨 Personalización

### Colores Corporativos
Edita `frontend/index.html` en la sección `:root`:
```css
:root {
    --azul-petci: #284A89;    /* Azul corporativo */
    --verde-limon: #9DD43B;    /* Verde limón */
    --gris-claro: #f5f7fa;
    --gris-medio: #e1e8ed;
}
```

### Prompts del Agente
Edita `backend/src/services/agentService.js`:
```javascript
instructions: `Tu nuevo prompt aquí...`
```

---

## 🔧 Desarrollo

### Iniciar en modo desarrollo
```bash
cd backend
npm run dev
```

### Ver logs en tiempo real
```bash
tail -f logs/backend.log
```

### Limpiar y reiniciar
```bash
# Matar procesos
lsof -ti:3000 | xargs kill -9
killall ngrok

# Reiniciar
./INICIAR_NGROK.sh
```

---

## 🐛 Solución de Problemas

### El diseño no se carga correctamente
```bash
# Solución: Abrir en modo incógnito
# Chrome/Edge: Cmd + Shift + N
# Safari: Cmd + Shift + P
```

### Puerto 3000 ocupado
```bash
lsof -ti:3000 | xargs kill -9
./INICIAR_NGROK.sh
```

### Archivos no se suben
```bash
# Verificar Vector Store ID
grep VECTOR_STORE_ID backend/.env

# Verificar permisos
chmod 755 backend/uploads
```

Para más problemas, consulta [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## 📊 Casos de Uso

### Para Ejecutivos
```
"Dame un resumen ejecutivo del análisis FODA"
"Proyecta los ingresos del próximo trimestre"
"¿Cuál es nuestra posición competitiva?"
```

### Para Operaciones
```
"Analiza los tiempos de atención de los últimos 6 meses"
"¿Qué equipos necesitan mantenimiento?"
"Dame el organigrama del área de Radiología"
```

### Para Marketing
```
"Extrae los colores del manual de marca"
"¿Cuál es nuestro posicionamiento actual?"
"Dame ideas para una campaña de prevención"
```

---

## 🚀 Deployment

### Desarrollo (ngrok)
```bash
./INICIAR_NGROK.sh
```

### Producción (Railway/Render/AWS)
1. Configura las variables de entorno
2. Deploy el directorio `backend/`
3. Apunta tu dominio al servidor

---

## 📈 Roadmap

### v1.1 (Próximas semanas)
- [ ] Autenticación de usuarios
- [ ] Persistencia de conversaciones
- [ ] Historial de chats
- [ ] Exportar conversaciones

### v1.2 (Próximos meses)
- [ ] Dashboard de analíticas
- [ ] Múltiples agentes especializados
- [ ] Integración con Google Drive
- [ ] App móvil (React Native)

---

## 🤝 Contribuciones

Este es un proyecto interno de PETCIMAGENES. Para mejoras o sugerencias, contacta al equipo de desarrollo.

---

## 📄 Licencia

Propietario: PETCIMAGENES
Uso interno exclusivo

---

## 📞 Soporte

Para problemas técnicos:
1. Revisa [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Verifica los logs: `tail -f logs/backend.log`
3. Contacta al equipo técnico

---

## ✅ Status

| Componente | Estado | Versión |
|------------|--------|---------|
| Backend | ✅ Producción | 1.0.0 |
| Frontend | ✅ Producción | 1.0.0 |
| Vector Store | ✅ Activo | vs_68f4701fe6c881918246bd8e88f0b974 |
| GPT-4o | ✅ Configurado | gpt-4o |
| Streaming | ✅ Funcional | Server-Sent Events |

---

**Última actualización:** Octubre 2025  
**Versión:** 1.0.0  
**Modelo:** GPT-4o  
**Autor:** Equipo de Desarrollo PETCIMAGENES
