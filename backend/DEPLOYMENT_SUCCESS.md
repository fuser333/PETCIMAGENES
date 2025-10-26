# DEPLOYMENT EXITOSO A VERCEL

## URLs DEL BACKEND EN PRODUCCIÓN

**URL Principal (canónica):**
```
https://petcimagenes-backend.vercel.app
```

**URL del último deployment:**
```
https://petcimagenes-backend-agbbgowe0-hector-velascos-projects.vercel.app
```

## ENDPOINTS DISPONIBLES

### 1. Health Check
```bash
curl https://petcimagenes-backend.vercel.app/api/health
```

**Respuesta esperada:**
```json
{
  "status": "ok",
  "timestamp": "2025-10-26T05:14:23.836Z",
  "env": {
    "hasOpenAIKey": true,
    "nodeEnv": "production"
  }
}
```

### 2. Chat (sin streaming)
```bash
curl -X POST "https://petcimagenes-backend.vercel.app/api/chat" \
  -H "Content-Type: application/json" \
  -d '{"message": "¿Qué es PETCIMAGENES?"}'
```

**Respuesta esperada:**
```json
{
  "success": true,
  "data": {
    "answer": "PETCIMAGENES es el primer centro privado...",
    "metadata": {
      "lastAgent": "PETCIMAGENES",
      "totalItems": 2
    }
  }
}
```

### 3. Chat con Streaming
```bash
curl -X POST "https://petcimagenes-backend.vercel.app/api/chat/stream" \
  -H "Content-Type: application/json" \
  -d '{"message": "Explícame el FODA de PETCIMAGENES"}' \
  --no-buffer
```

## PROBLEMAS RESUELTOS

### Problema Original
El backend funcionaba perfectamente en localhost:3000 pero fallaba en Vercel con:
```
FUNCTION_INVOCATION_FAILED
```

### Causa Raíz Identificada
1. **Logger con filesystem**: Winston intentaba escribir a archivos (`logs/error.log`) que no existen en serverless
2. **Multer con filesystem**: Intentaba guardar uploads en carpeta `uploads/` persistente
3. **Configuración incorrecta**: `vercel.json` tenía conflictos entre `builds` y `functions`
4. **Imports incorrectos**: Importaba servicios con dependencias de filesystem

### Solución Implementada

#### 1. Creación de versiones serverless
- `src/config/logger.vercel.js` - Logger basado en console.log
- `src/services/agentService.vercel.js` - Sin dependencias de filesystem
- `src/controllers/chatController.vercel.js` - Sin multer, solo JSON

#### 2. Configuración correcta de Vercel
```json
{
  "version": 2,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/api"
    }
  ],
  "functions": {
    "api/index.js": {
      "maxDuration": 60
    }
  }
}
```

#### 3. Entry point simplificado
`api/index.js` - Handler de Vercel que:
- Usa Express con CORS
- Importa controllers serverless
- Maneja errores correctamente
- NO usa multer ni filesystem

## CARACTERÍSTICAS ACTUALES

### Funcionando
- Health check endpoint
- Chat endpoint (sin streaming)
- Chat endpoint (con streaming SSE)
- Integración con OpenAI Agents SDK
- File Search (vector store)
- Web Search
- Code Interpreter
- Respuestas ejecutivas con citaciones

### Limitaciones en Vercel
- NO soporta upload de archivos (sin filesystem para multer)
- Timeout máximo: 60 segundos (300s con plan Pro)
- Cada request es stateless

### Para agregar soporte de archivos
Opciones:
1. Usar Vercel Blob Storage para uploads
2. Usar S3 o similar
3. Desplegar en Railway/Render (tienen filesystem)

## VARIABLES DE ENTORNO EN VERCEL

Asegúrate de tener configuradas en el dashboard de Vercel:
```
OPENAI_API_KEY=sk-proj-...
NODE_ENV=production
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
```

## PRÓXIMOS PASOS

1. Conectar el frontend a la nueva URL
2. Probar todas las funcionalidades
3. Configurar dominio custom (opcional)
4. Monitorear logs en producción

## BACKEND LOCAL

El backend local en `localhost:3000` sigue funcionando con todas las características:
- Upload de archivos
- Timeouts largos
- Logging a archivos
- Ngrok tunnel

No se eliminó ni modificó el código original.

## DEPLOYMENT

Para hacer un nuevo deployment:
```bash
cd backend
npx vercel --prod
```

O con el token:
```bash
VERCEL_ORG_ID=team_lKjPV0vwL4385ZmeKTZqqPtp \
VERCEL_PROJECT_ID=petcimagenes-backend \
npx vercel --token iQFvXm0UaNvtfVhDRZww6Zax --yes --prod
```

## LOGS

Para ver logs:
```bash
npx vercel logs petcimagenes-backend --token iQFvXm0UaNvtfVhDRZww6Zax
```

---

**Deployment exitoso:** 26 de Octubre 2025, 05:14 UTC
**Estado:** FUNCIONANDO
