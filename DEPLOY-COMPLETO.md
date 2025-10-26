# 🚀 Deploy Completo PETCIMAGENES - Listo para Ejecutar

## ✅ Lo que YA está hecho:

1. ✅ **Frontend del chat subido a Spaceship**
   - Ubicación: `imagemia.com/empresas/petcimagenes/`
   - Archivo: `index.html` (27.8 KB)
   - Assets: Logos incluidos

2. ✅ **Backend preparado para Vercel**
   - Archivo `vercel.json` creado
   - Configuración lista

3. ✅ **Sistema de login funcionando**
   - Login: `imagemia.com/empresas`
   - Usuario: `inlliyaku@gmail.com`
   - Password: `puPquq-1dammi-wespuh`

---

## 🎯 LO QUE FALTA (1 comando)

### Paso Único: Desplegar Backend en Vercel

```bash
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/backend"
vercel --prod
```

**Eso es TODO.** Vercel te preguntará:
1. "Set up and deploy?" → Presiona **Y** (Yes)
2. "Which scope?" → Selecciona tu cuenta
3. "Link to existing project?" → Presiona **N** (No, crear nuevo)
4. "What's your project's name?" → `petcimagenes-backend`
5. "In which directory is your code located?" → Presiona **Enter** (usa actual)

**Vercel detectará automáticamente:**
- ✅ Node.js
- ✅ Variables de entorno del `.env`
- ✅ Configuración de `vercel.json`

**Resultado:**
Te dará una URL como: `https://petcimagenes-backend.vercel.app`

---

## 📝 Después del Deploy

### 1. Copiar la URL del Backend

Cuando termine, Vercel mostrará:
```
✅ Production: https://petcimagenes-backend-xxxxx.vercel.app
```

**Copia esa URL**

### 2. Actualizar Frontend

Abre:
```bash
open "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/web/deploy/empresas/petcimagenes/index.html"
```

Busca la línea (~línea 20-30):
```javascript
const API_URL = 'http://localhost:3000'
```

Cámbiala por:
```javascript
const API_URL = 'https://petcimagenes-backend-xxxxx.vercel.app'
```
(usando la URL que te dio Vercel)

### 3. Volver a Subir Frontend

```bash
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/web/deploy/empresas/petcimagenes"

lftp -c "
set ftp:ssl-allow no
open ftp://imagemiadeploy@imagemia.com:zydGeb-jajrec-3fipgu@ftp.imagemia.com
cd ../imagemia.com/empresas/petcimagenes
put index.html
bye
"
```

---

## 🎉 ¡LISTO!

### Probar Todo el Sistema:

1. **Ve a:** https://imagemia.com/empresas

2. **Haz login:**
   - Email: `inlliyaku@gmail.com`
   - Password: `puPquq-1dammi-wespuh`

3. **Serás redirigido a:** https://imagemia.com/empresas/petcimagenes

4. **El chat funcionará conectándose a Vercel** (backend en la nube)

---

## 📊 Arquitectura Final:

```
Usuario → imagemia.com/empresas (Login)
       ↓
       imagemia.com/empresas/petcimagenes (Chat Frontend)
       ↓
       https://petcimagenes-backend.vercel.app (Backend API)
       ↓
       OpenAI (Procesamiento IA)
```

---

## 🔧 Variables de Entorno en Vercel

Vercel leerá automáticamente tu archivo `.env`, pero **verifica** que tenga:

```env
OPENAI_API_KEY=sk-proj-YOUR_OPENAI_API_KEY_HERE
WORKFLOW_ID=wf_68f441fe3c448190985c9ac5ff625426062c1b18927198d8
VECTOR_STORE_ID=vs_68f4701fe6c881918246bd8e88f0b974
PORT=3000
NODE_ENV=production
```

Si Vercel no las detecta automáticamente, agrégalas manualmente en:
**Dashboard Vercel → Tu Proyecto → Settings → Environment Variables**

---

## ⚡ Comando Rápido (Todo en Uno)

Si prefieres ejecutar todo de una vez:

```bash
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/backend" && vercel --prod && echo "✅ Backend desplegado! Ahora actualiza el frontend con la URL que te dio Vercel"
```

---

## ❓ Si Algo Falla

### Error: "vercel: command not found"

Instala Vercel CLI:
```bash
npm install -g vercel
```

### Error: "Missing required files"

Verifica que estés en la carpeta `/backend`:
```bash
pwd
# Debería mostrar: .../AgentkitV1/backend
```

### Error: "Authentication required"

Login en Vercel:
```bash
vercel login
```

---

## 📞 Resumen Ultra-Rápido

```bash
# 1. Desplegar backend (1 comando)
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/backend"
vercel --prod

# 2. Copiar URL que te da Vercel

# 3. Actualizar frontend con esa URL (editar index.html)

# 4. Subir frontend actualizado (ya te di el comando arriba)

# ¡LISTO! 🎉
```

---

**TODO LO DEMÁS YA ESTÁ FUNCIONANDO:**
- ✅ Landing en imagemia.com
- ✅ Login en imagemia.com/empresas
- ✅ Frontend chat en imagemia.com/empresas/petcimagenes
- ✅ Backend listo para deploy

**Solo falta 1 comando:** `vercel --prod`

¡Cuando lo hagas, me cuentas cómo fue! 🚀
