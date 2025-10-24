# 📚 INSTRUCCIONES DE DESPLIEGUE - IMAGEM.IA

Este directorio contiene todas las guías necesarias para desplegar el ecosistema completo de Imagem.ia.

---

## 🎯 VISIÓN GENERAL

### Arquitectura del Sistema:

```
imagemia.com
├── / (Raíz)
│   └── Landing page "En Construcción"
│
├── /empresas
│   └── Portal de login empresarial
│
└── /empresas/[nombre-empresa]
    └── AgentKit específico de cada empresa
    └── Ejemplo: /empresas/petcimagenes
```

---

## 📁 ESTRUCTURA DE CARPETAS

```
AgentkitV1/
├── web/                          # Sitios web públicos
│   ├── imagemia/                 # Landing principal
│   │   └── index.html
│   ├── empresas/                 # Portal empresarial
│   │   ├── index.html            # Login
│   │   └── petcimagenes/         # Empresa 1
│   │       └── index.html
│   └── [futuras-empresas]/
│
├── backend/                      # API y lógica de negocio
│   ├── src/
│   └── .env (local, no subir)
│
├── instrucciones/                # Documentación
│   └── conexiones-web/          # Guías de despliegue
│       ├── 01-CONFIGURAR-DNS-SPACESHIP.md
│       ├── 02-OPCIONES-DE-HOSTING.md
│       ├── 03-DESPLEGAR-EN-VERCEL.md
│       └── 04-DESPLEGAR-BACKEND-RAILWAY.md
│
└── .env.spaceship                # Credenciales Spaceship (NO SUBIR)
```

---

## 🚀 PLAN DE DESPLIEGUE (PASO A PASO)

### Fase 1: Landing Page (PRIMERO)

**Objetivo**: Tener imagemia.com funcionando con página "En Construcción"

**Pasos**:
1. Leer: `conexiones-web/01-CONFIGURAR-DNS-SPACESHIP.md`
2. Leer: `conexiones-web/02-OPCIONES-DE-HOSTING.md`
3. Seguir: `conexiones-web/03-DESPLEGAR-EN-VERCEL.md`

**Resultado**:
- ✅ `imagemia.com` funcionando
- ✅ SSL configurado
- ✅ Sitio "En Construcción" visible

**Tiempo estimado**: 2-4 horas (incluyendo propagación DNS)

---

### Fase 2: Portal Empresarial (SEGUNDO)

**Objetivo**: Agregar el login empresarial en /empresas

**Pasos**:
1. El archivo ya está creado: `web/empresas/index.html`
2. Ya está configurado en `vercel.json`
3. Hacer `git push` - se despliega automáticamente

**Resultado**:
- ✅ `imagemia.com/empresas` funcionando
- ✅ Sistema de login operativo
- ✅ Redirección a subdirectorios de empresas

**Tiempo estimado**: 30 minutos

---

### Fase 3: Backend en Producción (TERCERO)

**Objetivo**: Desplegar el backend Node.js con OpenAI

**Pasos**:
1. Seguir: `conexiones-web/04-DESPLEGAR-BACKEND-RAILWAY.md`
2. Configurar variables de entorno
3. Probar endpoints

**Resultado**:
- ✅ Backend corriendo en Railway
- ✅ API accesible públicamente
- ✅ Variables de entorno seguras

**Tiempo estimado**: 1-2 horas

---

### Fase 4: Conectar Todo (CUARTO)

**Objetivo**: Que el frontend use el backend de producción

**Pasos**:
1. Actualizar URLs en frontend
2. Probar flujo completo
3. Verificar chat funcionando

**Resultado**:
- ✅ Sistema completo funcionando
- ✅ Chat con IA operativo
- ✅ Upload de archivos funcionando

**Tiempo estimado**: 1 hora

---

## 🔐 SEGURIDAD

### Archivos que NUNCA deben subirse a GitHub:

```
.env
.env.local
.env.spaceship
backend/.env
```

Estos archivos ya están protegidos por `.gitignore`.

### Credenciales actuales:

- ✅ API Key Spaceship: Guardada en `.env.spaceship`
- ✅ API Key OpenAI: Guardada en `backend/.env`
- ⚠️ **IMPORTANTE**: Regenerar API OpenAI si fue expuesta

---

## 🎨 DISEÑO

### Colores principales:

- **Verde principal**: `#10B981` (Emerald 500)
- **Verde oscuro**: `#059669` (Emerald 600)
- **Blanco**: `#FFFFFF`

Estos colores están en:
- Landing page (`web/imagemia/index.html`)
- Portal login (`web/empresas/index.html`)

Puedes cambiarlos fácilmente editando el CSS en cada archivo.

---

## 📊 COSTOS ESTIMADOS

### Inicio (Gratis):
- **Dominio (Spaceship)**: ~$12/año
- **Vercel**: $0/mes
- **Railway**: $5 gratis/mes
- **Total**: ~$1/mes

### Producción (Escalado):
- **Dominio**: ~$12/año
- **Vercel Pro**: $20/mes
- **Railway**: $10-20/mes
- **Total**: ~$30-40/mes

---

## 🆘 SOPORTE

### Si algo no funciona:

1. Revisar la guía específica en `conexiones-web/`
2. Verificar logs:
   - Vercel: Dashboard → Deployments → Logs
   - Railway: Dashboard → Project → Logs
3. Revisar DNS: https://dnschecker.org

### Contacto:
- Crear issue en GitHub
- Revisar documentación de cada servicio

---

## ✅ CHECKLIST DE DESPLIEGUE

Marca cada paso cuando lo completes:

- [ ] DNS configurado en Spaceship
- [ ] Vercel conectado con GitHub
- [ ] Landing page desplegada
- [ ] SSL funcionando (HTTPS)
- [ ] Portal /empresas funcionando
- [ ] Railway configurado
- [ ] Backend desplegado
- [ ] Variables de entorno configuradas
- [ ] Frontend conectado con backend
- [ ] Chat con IA funcionando
- [ ] Upload de archivos funcionando

---

## 🎉 PRÓXIMOS PASOS (FUTURO)

Una vez todo funcionando:

1. **Autenticación real con Supabase**
   - Reemplazar el login hardcodeado
   - Agregar registro de usuarios
   - Gestionar permisos

2. **Agregar más empresas**
   - Crear carpeta `web/empresas/[nueva-empresa]`
   - Agregar credenciales en el login
   - Configurar Vector Store específico

3. **Analytics**
   - Google Analytics
   - Monitoreo de errores
   - Métricas de uso

4. **Mejoras de diseño**
   - Agregar logo cuando esté listo
   - Personalizar colores de marca
   - Mejorar UX

---

**¡Éxito con el despliegue!** 🚀
