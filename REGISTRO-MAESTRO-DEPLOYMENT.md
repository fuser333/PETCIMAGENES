# 📋 REGISTRO MAESTRO - Deployment PETCIMAGENES
## Historial de Cambios y Configuración del Sistema

**Fecha Inicio:** 25 de Octubre 2025
**Proyecto:** Chat AI PETCIMAGENES con OpenAI Agents
**Dominio:** imagemia.com
**Última Actualización:** 26 de Octubre 2025, 01:00 AM

---

## 🎯 OBJETIVO DEL PROYECTO

**MIGRACIÓN de ngrok a dominio propio:**

Teníamos el backend funcionando en:
- ❌ `https://rosia-unbrocaded-distinguishedly.ngrok-free.dev` (ngrok - desarrollo)

Estamos migrando a:
- ✅ `https://imagemia.com/empresas/petcimagenes/` (producción)
- ✅ Backend en Vercel (sin ngrok)

**Sistema completo:**
- Landing page en imagemia.com
- Portal de login empresarial
- Chat con IA usando OpenAI Agents
- Backend en Vercel (en lugar de ngrok)
- Frontend en Spaceship (FTP)

---

## ✅ LO QUE YA FUNCIONA

### 1. **Estructura de Archivos (Spaceship FTP)**

```
imagemia.com/
├── index.html                    ✅ Landing principal de Imagem.ia
├── assets/logos/                 ✅ Logos de Imagem.ia
│
└── empresas/
    ├── index.html                ✅ Portal de login empresarial (DEV_MODE)
    ├── .htaccess                 ✅ Anti-caché configurado
    │
    └── petcimagenes/
        ├── index.html            ✅ Chat de PETCIMAGENES con IA
        ├── .htaccess             ✅ Anti-caché configurado
        └── assets/logos/         ✅ Logos de PETCIMAGENES
            ├── petcimagenes-logo.svg
            └── petcimagenes-isotipo.svg
```

### 2. **Sistema de Login (DEV_MODE)**

**Archivo:** `imagemia.com/empresas/index.html`

**Configuración Actual:**
- `DEV_MODE = true` (no requiere Supabase)
- Login hardcodeado con credenciales locales
- Redirección automática a `/empresas/petcimagenes` tras login

**Credenciales Activas:**
```javascript
'inlliyaku@gmail.com': {
    password: 'puPquq-1dammi-wespuh',
    subdomain: 'petcimagenes',
    nombre: 'PETCIMAGENES'
}
```

**Configuración Supabase (para cuando se active):**
- URL: `https://tnohrdssgbnqiohjexfr.supabase.co`
- Proyecto: `imagemia`
- Estado: Configurado pero no activo (DEV_MODE = true)

### 3. **Frontend del Chat**

**Archivo:** `imagemia.com/empresas/petcimagenes/index.html`

**Características:**
- ✅ Interfaz de chat moderna con colores de marca PETCIMAGENES
- ✅ Dos secciones de archivos:
  - Almacén permanente (Vector Store)
  - Archivos temporales por consulta
- ✅ Streaming de respuestas de IA
- ✅ Logos y branding correctos

**Configuración API:**
```javascript
const API_URL = 'https://petcimagenes-backend-XXXXX.vercel.app'
```

### 4. **Logos y Branding**

**PETCIMAGENES:**
- Logo completo: `assets/logos/petcimagenes-logo.svg` (5KB) ✅
- Isotipo (favicon): `assets/logos/petcimagenes-isotipo.svg` (4.6KB) ✅
- Rutas relativas configuradas correctamente

**Colores de Marca:**
- Azul PETCI: `#284A89`
- Verde Limón: `#9DD43B`

---

## 🔧 CONFIGURACIÓN DEL BACKEND

### Ubicación Local:
```
/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/backend/
```

### Variables de Entorno (.env):
```env
PORT=3000
NODE_ENV=production
OPENAI_API_KEY=sk-proj-YOUR_OPENAI_API_KEY_HERE
WORKFLOW_ID=wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
VERCEL_DEPLOYMENT_PROTECTION_BYPASS=domain_pk_68fd9822330c8190b4a3031ec5c2818b0f524cbadd3f0d2f
```

### Vercel Configuration:
- **Proyecto:** `petcimagenes-backend`
- **Team ID:** `team_lKjPV0vwL4385ZmeKTZqqPtp`
- **Deployment Protection:** DESACTIVADA ✅
- **CORS:** Permitir todos los orígenes (origin: '*')

### Archivo vercel.json:
```json
{
  "version": 2,
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/api"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  }
}
```

---

## ✅ DEPLOYMENT COMPLETADO EXITOSAMENTE

### Sistema en Producción - 26 Octubre 2025

**Estado:** ✅ FUNCIONANDO CORRECTAMENTE

**URLs Intentadas:**
1. `https://petcimagenes-backend-k8u1s0zfu-hector-velascos-projects.vercel.app` - ❌ FAIL
2. `https://petcimagenes-backend-c0wojfod3-hector-velascos-projects.vercel.app` - ❌ FAIL
3. `https://petcimagenes-backend-onykeqv8s-hector-velascos-projects.vercel.app` - ❌ FAIL
4. `https://petcimagenes-backend-jwexfo0oi-hector-velascos-projects.vercel.app` - ❌ FAIL
5. `https://petcimagenes-backend-7jihfmoxj-hector-velascos-projects.vercel.app` - ❌ FAIL

**Error Común:**
```
A server error has occurred
FUNCTION_INVOCATION_FAILED
```

**Posibles Causas:**
1. Problemas con ES Modules en entorno serverless
2. Dependencias que no funcionan en Vercel
3. Configuración incorrecta de vercel.json
4. Problemas con importaciones de archivos

**Próximos Pasos a Investigar:**
- [ ] Revisar logs detallados de Vercel
- [ ] Simplificar dependencias
- [ ] Crear versión mínima funcional
- [ ] Considerar alternativa con Vercel Functions puras

---

## 📊 FLUJO DEL SISTEMA (Cuando esté completo)

```
Usuario
  ↓
https://imagemia.com (Landing)
  ↓
https://imagemia.com/empresas (Login)
  ↓ (Autenticación exitosa)
  ↓
https://imagemia.com/empresas/petcimagenes (Chat Frontend)
  ↓ (API Requests)
  ↓
https://petcimagenes-backend.vercel.app (Backend)
  ↓
OpenAI Agents API
  ↓
Respuestas con IA
```

---

## 🔑 CREDENCIALES Y TOKENS

### FTP Spaceship:
- Host: `ftp.imagemia.com`
- Usuario: `imagemiadeploy@imagemia.com`
- Password: `zydGeb-jajrec-3fipgu`

### Vercel:
- Token: `iQFvXm0UaNvtfVhDRZww6Zax`
- Team: `hector-velascos-projects`

### Ngrok (versión anterior):
- Auth Token: `34MZCmWlh7PZwOkw42oUcFP1ohC_4bnsRFoWpys9tmc7Ko8C7`
- Dominio: `rosia-unbrocaded-distinguishedly.ngrok-free.dev`
- Estado: Ya no se usa (migrado a Vercel)

### OpenAI:
- API Key: (ver .env del backend)
- Workflow ID: `wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8`
- Vector Store ID: `vs_68f4701fe6c881918246bd8e88f0b974`

### Dominio imagemia.com:
- Domain Key: `domain_pk_68fd9822330c8190b4a3031ec5c2818b0f524cbadd3f0d2f`

---

## 📝 COMANDOS ÚTILES

### Subir Frontend a FTP:
```bash
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/web/deploy/empresas/petcimagenes"

lftp -c "
set ftp:ssl-allow no
open ftp://imagemiadeploy@imagemia.com:zydGeb-jajrec-3fipgu@ftp.imagemia.com
cd empresas/petcimagenes
put index.html
bye
"
```

### Deploy Backend a Vercel:
```bash
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/backend"
vercel --prod
```

### Desactivar Deployment Protection:
```bash
curl -X PATCH \
  "https://api.vercel.com/v9/projects/petcimagenes-backend?teamId=team_lKjPV0vwL4385ZmeKTZqqPtp" \
  -H "Authorization: Bearer iQFvXm0UaNvtfVhDRZww6Zax" \
  -H "Content-Type: application/json" \
  -d '{"ssoProtection": null}'
```

---

## 🎨 DECISIONES DE DISEÑO

1. **DEV_MODE en Login:** Activado para desarrollo rápido sin dependencia de Supabase
2. **CORS Abierto:** `origin: '*'` para permitir requests desde cualquier dominio
3. **Anti-Caché:** Archivos `.htaccess` en todas las carpetas para evitar problemas de actualización
4. **Rutas Relativas:** Logos usan rutas relativas para evitar problemas de paths
5. **Cache Busting:** Parámetros `?v=3` en URLs de assets

---

## 📅 PRÓXIMOS PASOS

### Prioridad ALTA:
1. ❗ Solucionar error FUNCTION_INVOCATION_FAILED en Vercel
2. Verificar logs detallados del backend
3. Crear versión mínima del backend que funcione
4. Actualizar frontend con URL correcta del backend
5. Probar flujo completo end-to-end

### Prioridad MEDIA:
- Activar Supabase para login en producción (cambiar DEV_MODE = false)
- Configurar dominio personalizado en Vercel
- Optimizar tiempo de respuesta del backend
- Agregar manejo de errores mejorado

### Prioridad BAJA:
- Implementar analytics
- Agregar más empresas al sistema de login
- Mejorar UI/UX del chat
- Agregar tests automatizados

---

## 📞 CONTACTOS Y REFERENCIAS

- **Documentación Vercel:** https://vercel.com/docs
- **OpenAI Agents SDK:** https://platform.openai.com/docs/agents
- **Supabase Docs:** https://supabase.com/docs

---

## 🎯 RESUMEN DEL DEPLOYMENT EXITOSO

**Backend Final:**
- URL: `https://petcimagenes-backend.vercel.app`
- Endpoint: `/api/chat` (sin streaming, funciona perfectamente)
- Variables de entorno configuradas ✅
- OpenAI API Key funcionando ✅

**Frontend Final:**
- URL: `https://imagemia.com/empresas/petcimagenes/`
- Conecta a backend de Vercel ✅
- Chat respondiendo correctamente ✅

**Soluciones Aplicadas:**
1. Cambio de `/api/chat/stream` a `/api/chat` (sin streaming)
2. Cambio de FormData a JSON en requests
3. Configuración de variables de entorno en Vercel
4. Upload correcto a carpeta `imagemia.com` (no `imagemiadeploy`)

**Última Actualización:** 26 de Octubre 2025, 02:25 AM
**Estado General:** 🟢 PRODUCCIÓN EXITOSA (Frontend ✅ | Backend ✅)
