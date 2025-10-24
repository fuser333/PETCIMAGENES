# 🚂 DESPLEGAR BACKEND EN RAILWAY - GUÍA COMPLETA

## ¿Por qué Railway?

- ✅ Soporte nativo para Node.js
- ✅ Variables de entorno seguras
- ✅ Despliegue automático desde GitHub
- ✅ $5 gratis cada mes
- ✅ Bases de datos integradas (si las necesitas)

---

## Paso 1: Crear cuenta en Railway

1. Ir a https://railway.app
2. Click en **"Login"**
3. Seleccionar **"Login with GitHub"**
4. Autorizar Railway

---

## Paso 2: Preparar el backend para producción

### A) Crear archivo `Procfile` en la carpeta `backend/`:

```bash
web: node src/server.js
```

### B) Verificar `package.json` en `backend/`:

Asegúrate de que tenga el script de inicio:

```json
{
  "scripts": {
    "start": "node src/server.js",
    "dev": "nodemon src/server.js"
  }
}
```

### C) Actualizar `backend/src/server.js` para usar variable de entorno:

```javascript
const PORT = process.env.PORT || 3000;
```

---

## Paso 3: Subir cambios a GitHub

```bash
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1"

git add backend/Procfile backend/package.json
git commit -m "Preparar backend para Railway"
git push
```

---

## Paso 4: Crear proyecto en Railway

1. En Railway, click en **"New Project"**
2. Seleccionar **"Deploy from GitHub repo"**
3. Buscar **"PETCIMAGENES"**
4. Click en el repositorio

### Configuración:

```
Root Directory: backend
Build Command: npm install
Start Command: npm start
```

---

## Paso 5: Configurar variables de entorno

1. En Railway, ir a tu proyecto
2. Click en **"Variables"**
3. Agregar estas variables:

```env
NODE_ENV=production
PORT=3000
OPENAI_API_KEY=tu-api-key-real-aqui
WORKFLOW_ID=wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
```

⚠️ **IMPORTANTE**: Usa tu API key real de OpenAI aquí (la del archivo `.env` local)

---

## Paso 6: Desplegar

1. Railway detectará automáticamente el proyecto
2. Iniciará el build y despliegue
3. Espera 2-3 minutos

---

## Paso 7: Obtener URL de producción

1. Una vez desplegado, Railway te dará una URL como:
   ```
   https://petcimagenes-production-xxxx.up.railway.app
   ```

2. Copia esta URL - la necesitarás para configurar el frontend

---

## Paso 8: Configurar dominio personalizado (Opcional)

### Opción A: Usar subdominio de Railway (gratis)
Ya tienes una URL funcionando - no necesitas hacer nada más.

### Opción B: Usar tu propio dominio

1. En Railway, ir a **"Settings"** → **"Domains"**
2. Click en **"Add Domain"**
3. Ingresar: `api.imagemia.com`

Railway te dará un CNAME record:

```
Type: CNAME
Name: api
Value: xxxx.railway.app
TTL: 3600
```

4. Agregar este record en Spaceship DNS
5. Esperar propagación (1-48 horas)

---

## Paso 9: Actualizar frontend para usar backend de producción

Necesitas actualizar el frontend para que use la URL de Railway:

### En `web/empresas/petcimagenes/index.html`:

Cambiar de:
```javascript
window.location.href = 'http://localhost:8080';
```

A:
```javascript
// Usar el backend de producción
const API_URL = 'https://tu-url-de-railway.up.railway.app';
window.location.href = API_URL;
```

O mejor aún, crear una variable de entorno en Vercel.

---

## Paso 10: Verificar que funciona

### Probar endpoints:

```bash
# Health check
curl https://tu-url-railway.up.railway.app/health

# Debería responder: {"status":"OK"}
```

---

## 🔄 DESPLIEGUE AUTOMÁTICO

Igual que Vercel, cada `git push` a GitHub:
1. Railway detecta cambios
2. Hace rebuild
3. Despliega automáticamente
4. ~2-3 minutos para actualizar

---

## 💰 COSTOS

- **Gratis**: $5 de crédito cada mes
- **Uso estimado**: ~$5-10/mes para este proyecto
- Si excedes los $5 gratis, se cobra el excedente

---

## 🐛 SOLUCIÓN DE PROBLEMAS

### Error: "Application failed to respond"
- Verifica que `PORT` use `process.env.PORT`
- Revisa logs en Railway Dashboard
- Verifica que las variables de entorno estén configuradas

### Error: "Build failed"
- Verifica que `package.json` esté correcto
- Revisa que todas las dependencias estén instaladas
- Mira los logs de build en Railway

### El chat no funciona
- Verifica que `OPENAI_API_KEY` esté configurada
- Verifica que la API key sea válida
- Revisa logs para ver errores de OpenAI

---

## 📊 MONITOREO

Railway ofrece:
- ✅ Logs en tiempo real
- ✅ Métricas de uso (CPU, RAM)
- ✅ Alertas por email

Accede a todo esto desde el Dashboard de Railway.

---

## 🎉 RESULTADO FINAL

Ahora tienes:
- ✅ Backend en Railway con SSL
- ✅ Variables de entorno seguras
- ✅ Despliegue automático
- ✅ Logs y monitoreo
- ✅ URL pública funcionando

---

## 📝 PRÓXIMO PASO

Una vez funcionando el backend, continúa con:
- `05-CONECTAR-FRONTEND-BACKEND.md`
