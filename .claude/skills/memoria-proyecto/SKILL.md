# Memoria del Proyecto - PETCIMAGENES

**Nombre:** memoria-proyecto
**Descripción:** Sistema de memoria persistente para recordar configuración, credenciales y progreso del proyecto PETCIMAGENES

---

## 🎯 PROPÓSITO

Esta skill mantiene un registro actualizado y persistente de:
- Configuraciones del proyecto
- Credenciales y tokens
- URLs y dominios
- Progreso y tareas completadas
- Decisiones técnicas importantes
- Problemas encontrados y soluciones

---

## 📋 USO

**Cuando inicies una sesión:**
1. Lee `REGISTRO-MAESTRO-DEPLOYMENT.md` para recuperar contexto
2. Actualiza el registro con nuevos cambios realizados
3. Documenta cualquier decisión importante
4. Guarda credenciales de forma segura

**Antes de terminar una sesión:**
1. Actualiza el registro con el progreso del día
2. Documenta problemas pendientes
3. Lista próximos pasos priorizados

---

## 📁 ARCHIVOS PRINCIPALES

### Documentación Central:
- `REGISTRO-MAESTRO-DEPLOYMENT.md` - Registro completo y actualizado
- `CUANDO-VUELVAS-LEE-ESTO.txt` - Resumen ejecutivo rápido
- `SESION_*.md` - Resúmenes de sesiones anteriores

### Configuración que Funcionaba:
- `INICIAR_CON_NGROK_APROBADO.md` - Backend funcionando con ngrok
- `RESUMEN_SESION_23_OCT_2025_NOCHE.md` - Última configuración estable

---

## 🔑 INFORMACIÓN CRÍTICA

### URLs Actuales:
```
- Frontend: https://imagemia.com/empresas/petcimagenes/
- Backend ngrok (viejo): https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
- Backend Vercel (nuevo): [EN PROCESO]
- Login: https://imagemia.com/empresas
```

### Credenciales de Login:
```
Email: inlliyaku@gmail.com
Password: puPquq-1dammi-wespuh
```

### FTP Spaceship:
```
Host: ftp.imagemia.com
Usuario: imagemiadeploy@imagemia.com
Password: zydGeb-jajrec-3fipgu
```

### Vercel:
```
Token: iQFvXm0UaNvtfVhDRZww6Zax
Team: hector-velascos-projects
Proyecto: petcimagenes-backend
```

### Ngrok (versión anterior):
```
Auth Token: 34MZCmWlh7PZwOkw42oUcFP1ohC_4bnsRFoWpys9tmc7Ko8C7
Dominio: rosia-unbrocaded-distinguishedly.ngrok-free.dev
Estado: Ya no se usa (migrado a Vercel)
```

### OpenAI:
```
Workflow ID: wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8
Vector Store ID: vs_68f4701fe6c881918246bd8e88f0b974
URL aprobada (ngrok): rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

### Dominio imagemia.com:
```
Domain Key: domain_pk_68fd9822330c8190b4a3031ec5c2818b0f524cbadd3f0d2f
```

---

## 📊 ESTADO ACTUAL DEL PROYECTO

### ✅ Completado:
1. Frontend desplegado en Spaceship (imagemia.com/empresas/petcimagenes/)
2. Login funcionando con DEV_MODE
3. Logos correctamente ubicados y visibles
4. Deployment Protection desactivada en Vercel
5. CORS configurado en backend
6. Archivo maestro de documentación creado

### ✅ SISTEMA EN PRODUCCIÓN - 26 Oct 2025:
1. **Backend deployed en Vercel**
   - URL: https://petcimagenes-backend.vercel.app
   - Endpoint: /api/chat (sin streaming)
   - Variables de entorno configuradas
   - Estado: FUNCIONANDO ✅

2. **Frontend actualizado**
   - URL: https://imagemia.com/empresas/petcimagenes/
   - Conectado al backend de Vercel
   - Chat respondiendo correctamente
   - Estado: FUNCIONANDO ✅

3. **Migración completada**
   - De ngrok local → Vercel en producción
   - Sin dependencia de localhost
   - Sistema completo funcionando 24/7

---

## 🚀 PRÓXIMOS PASOS PRIORITARIOS

### ALTA PRIORIDAD:
1. **Solucionar backend en Vercel**
   - Opción A: Copiar configuración exacta que funcionaba con ngrok
   - Opción B: Crear versión minimalista para Vercel
   - Opción C: Usar alternativa (Railway, Render)

2. **Actualizar frontend con URL correcta del backend**
   - Una vez backend funcione

### MEDIA PRIORIDAD:
3. Verificar que chat funcione end-to-end
4. Probar upload de archivos
5. Testing completo del flujo de usuario

---

## 🔧 CONFIGURACIÓN QUE FUNCIONABA

### Backend con ngrok:
- Ubicación: `/Users/hbva/AgentkitV1/backend`
- Script inicio: `INICIAR_BACKEND_CORRECTO.sh`
- Puerto: 3000
- Formato streaming: CORREGIDO (envía `{content: "texto"}`)
- Ngrok command: `ngrok http 3000 --domain=rosia-unbrocaded-distinguishedly.ngrok-free.dev`

### Formato de Eventos Correcto:
```javascript
for await (const event of stream) {
  if (event.type === 'text_delta' && event.content) {
    res.write(`data: ${JSON.stringify({ content: event.content })}\n\n`);
  } else if (event.type === 'done') {
    res.write(`data: [DONE]\n\n`);
  } else if (event.type === 'tool_call') {
    res.write(`data: ${JSON.stringify({
      type: 'status',
      message: `🔧 Usando ${event.tool}...`
    })}\n\n`);
  }
}
```

---

## 📝 DECISIONES TÉCNICAS

### Arquitectura:
- **Frontend:** Spaceship FTP (hosting estático)
- **Backend:** Vercel (serverless) - antes era ngrok local
- **Base de Datos:** No requerida (usa OpenAI Vector Store)
- **Auth:** DEV_MODE (hardcoded) - futuro: Supabase

### Por qué Vercel en lugar de ngrok:
1. Ngrok requiere mantener computadora encendida
2. Vercel es gratuito para proyectos pequeños
3. SSL/HTTPS automático
4. Deploy automático desde git
5. URL permanente (no cambia)

### Problemas con Vercel:
1. Serverless functions tienen limitaciones
2. ES Modules pueden causar problemas
3. Algunas dependencias no funcionan en serverless
4. Timeout limits (10 min máximo)

---

## 🐛 DEBUGGING LOG

### Issue #1: Backend fails with FUNCTION_INVOCATION_FAILED
**Fecha:** 26 Oct 2025, 00:30-01:00
**Intentos:**
1. Deployment con builds en vercel.json - ❌ FAIL
2. Deployment con rewrites - ❌ FAIL
3. API route en /api/index.js - ❌ FAIL
4. Versión simplificada sin app.js - ❌ FAIL

**Hipótesis:**
- Problema con importaciones ES modules
- Dependencias incompatibles con serverless
- Configuración incorrecta de entry point

**Próximo intento:**
- Copiar EXACTAMENTE la configuración que funcionaba con ngrok
- Crear wrapper mínimo para Vercel
- Verificar logs detallados en Vercel

---

## 📚 COMANDOS ÚTILES

### Actualizar Registro:
```bash
# Abrir y editar
code "REGISTRO-MAESTRO-DEPLOYMENT.md"

# Agregar al final
echo "## [$(date)] - Cambio realizado" >> REGISTRO-MAESTRO-DEPLOYMENT.md
```

### Verificar Estado:
```bash
# Ver últimos cambios
tail -50 REGISTRO-MAESTRO-DEPLOYMENT.md

# Buscar configuración específica
grep -r "API_URL" web/deploy/
grep -r "OPENAI" backend/
```

### Backup Rápido:
```bash
# Crear snapshot del estado actual
cp REGISTRO-MAESTRO-DEPLOYMENT.md "BACKUP_$(date +%Y%m%d_%H%M).md"
```

---

## 🎓 LECCIONES APRENDIDAS

1. **Siempre documentar la configuración que funciona**
   - Antes de hacer cambios grandes
   - Especialmente URLs y credenciales
   - Formato exacto de datos (ej: streaming events)

2. **No borrar versiones que funcionan**
   - Mantener backup del código funcionando con ngrok
   - Antes de migrar a nueva plataforma

3. **Serverless != Traditional Server**
   - Vercel tiene limitaciones específicas
   - No todas las dependencias funcionan
   - Entry points diferentes

4. **Cache es el enemigo del desarrollo web**
   - Siempre usar incógnito para testing
   - Hard refresh (Cmd+Shift+R)
   - Archivos .htaccess para desactivar cache

---

## 🔄 ACTUALIZAR ESTA SKILL

Cada vez que completes una tarea importante:

1. Actualiza la sección "Estado Actual"
2. Mueve items de "En Progreso" a "Completado"
3. Agrega nuevos "Próximos Pasos"
4. Documenta decisiones en "Decisiones Técnicas"
5. Actualiza credenciales si cambian
6. Agrega problemas a "Debugging Log"

**Esta skill debe ser el ÚNICO source of truth del proyecto.**

---

---

## 🔍 INVESTIGACIÓN DE TIMEOUT - 26 Oct 2025

### Problema Identificado:
**Web search falla con 504 timeout** cuando OpenAI tarda >60 segundos.

### Causa Confirmada:
- ✅ **NO es problema de Spaceship** (frontend funciona perfecto)
- ✅ **NO es problema de OpenAI** (funciona en su playground)
- ❌ **ES problema de Vercel Free:** Límite de 60 segundos HTTP

### Solución Recomendada:
**Implementar patrón Async con Upstash Redis (Gratis)**
- Tiempo: 2-3 horas
- Costo: $0
- Escalable para cualquier duración

**Alternativa:** Railway ($5/mes, más simple)

### Pendiente Verificar:
- [ ] Estado del hosting Spaceship (¿pagado?)
- [ ] Decisión: ¿Implementar async o migrar a Railway?

---

**Última Actualización:** 26 de Octubre 2025, 02:35 AM
**Actualizado por:** Claude Code Assistant + Agente de Investigación
**Próxima Revisión:** Al iniciar próxima sesión
