# 🚀 DESPLEGAR EN VERCEL - GUÍA COMPLETA

## Paso 1: Crear cuenta en Vercel

1. Ir a https://vercel.com
2. Click en **"Sign Up"**
3. Seleccionar **"Continue with GitHub"**
4. Autorizar Vercel para acceder a tus repositorios

---

## Paso 2: Preparar el repositorio

Antes de desplegar, necesitas crear un archivo de configuración:

### Crear `vercel.json` en la raíz del proyecto:

```json
{
  "version": 2,
  "builds": [
    {
      "src": "web/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/",
      "dest": "/web/imagemia/index.html"
    },
    {
      "src": "/empresas",
      "dest": "/web/empresas/index.html"
    },
    {
      "src": "/empresas/petcimagenes",
      "dest": "/web/empresas/petcimagenes/index.html"
    }
  ],
  "rewrites": [
    { "source": "/(.*)", "destination": "/web/$1" }
  ]
}
```

---

## Paso 3: Subir cambios a GitHub

```bash
# En tu terminal, en la carpeta del proyecto:
cd "/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1"

# Agregar el archivo vercel.json
git add vercel.json

# Hacer commit
git commit -m "Configuración para despliegue en Vercel"

# Subir a GitHub
git push
```

---

## Paso 4: Importar proyecto en Vercel

1. En Vercel, click en **"Add New..."** → **"Project"**
2. Buscar tu repositorio **"PETCIMAGENES"**
3. Click en **"Import"**

### Configuración del proyecto:

```
Framework Preset: Other
Root Directory: ./
Build Command: (dejar vacío)
Output Directory: web
Install Command: (dejar vacío)
```

4. Click en **"Deploy"**

---

## Paso 5: Configurar dominio personalizado

1. Una vez desplegado, ir a **"Settings"** → **"Domains"**
2. Click en **"Add"**
3. Ingresar: `imagemia.com`
4. Click en **"Add"**

### Vercel te dará instrucciones DNS:

```
Type: A
Name: @
Value: 76.76.21.21

Type: CNAME
Name: www
Value: cname.vercel-dns.com
```

---

## Paso 6: Configurar DNS en Spaceship

1. Ir a Spaceship.com → My Domains → imagemia.com
2. Click en **"DNS Management"**
3. Agregar los registros que te dio Vercel:

```
A Record:
Host: @
Value: 76.76.21.21
TTL: 3600

CNAME Record:
Host: www
Value: cname.vercel-dns.com
TTL: 3600
```

4. **Guardar cambios**

---

## Paso 7: Esperar propagación

- Los cambios DNS pueden tardar **1-48 horas**
- Vercel verificará automáticamente
- Cuando esté listo, verás un ✅ en Vercel

---

## Paso 8: Configurar SSL (Automático)

Vercel configura SSL automáticamente:
- ✅ Certificado Let's Encrypt gratuito
- ✅ Renovación automática
- ✅ HTTPS forzado

**No necesitas hacer nada!**

---

## 🎉 RESULTADO FINAL

Después de la propagación DNS:

- ✅ `imagemia.com` → Landing page "En Construcción"
- ✅ `www.imagemia.com` → Redirige a imagemia.com
- ✅ `imagemia.com/empresas` → Portal de login
- ✅ `imagemia.com/empresas/petcimagenes` → AgentKit
- ✅ HTTPS habilitado automáticamente

---

## 🔄 DESPLIEGUE AUTOMÁTICO

Ahora, cada vez que hagas `git push`:
1. GitHub recibe el código
2. Vercel detecta el cambio
3. Automáticamente despliega la nueva versión
4. Tu sitio se actualiza en ~30 segundos

---

## 🐛 SOLUCIÓN DE PROBLEMAS

### Error: "Domain not verified"
- Espera más tiempo (hasta 48 horas)
- Verifica que los DNS records sean exactos
- Usa https://dnschecker.org para verificar propagación

### Error: "Build failed"
- Verifica que `vercel.json` esté en la raíz
- Revisa los logs en Vercel Dashboard

### El sitio no carga
- Verifica que los archivos estén en la carpeta `web/`
- Revisa las rutas en `vercel.json`

---

## 📝 PRÓXIMO PASO

Una vez funcionando el frontend, continúa con:
- `04-DESPLEGAR-BACKEND-RAILWAY.md`
