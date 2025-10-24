# 🖥️ OPCIONES DE HOSTING PARA IMAGEM.IA

## ⚠️ IMPORTANTE: Spaceship y Hosting

**Spaceship** es principalmente un **registrador de dominios**, NO un proveedor de hosting completo.

Necesitarás un servicio de hosting separado para alojar tu aplicación.

---

## 🎯 OPCIONES RECOMENDADAS

### Opción 1: Vercel (RECOMENDADO para frontend)

**Ventajas:**
- ✅ Gratis para proyectos pequeños
- ✅ Despliegue automático desde GitHub
- ✅ SSL automático
- ✅ CDN global
- ✅ Fácil configuración de dominios personalizados

**Ideal para:**
- Landing page principal (imagemia.com)
- Página de login (/empresas)

**Cómo configurar:**
1. Ir a https://vercel.com
2. Conectar con GitHub
3. Importar repositorio PETCIMAGENES
4. Configurar dominio personalizado
5. Listo - despliegue automático en cada commit

---

### Opción 2: Railway (RECOMENDADO para backend Node.js)

**Ventajas:**
- ✅ Soporte completo para Node.js
- ✅ Bases de datos incluidas
- ✅ Variables de entorno seguras
- ✅ Despliegue desde GitHub
- ✅ $5/mes crédito gratis

**Ideal para:**
- Backend del AgentKit (Express.js)
- API endpoints

**Cómo configurar:**
1. Ir a https://railway.app
2. Conectar con GitHub
3. Importar repositorio
4. Configurar variables de entorno (.env)
5. Desplegar

---

### Opción 3: DigitalOcean Droplet (Para control total)

**Ventajas:**
- ✅ Control completo del servidor
- ✅ Escalable
- ✅ Desde $6/mes

**Desventajas:**
- ⚠️ Requiere configuración manual
- ⚠️ Necesitas conocimientos de DevOps

**Ideal para:**
- Aplicaciones empresariales
- Múltiples clientes/empresas
- Base de datos propias

---

### Opción 4: Netlify (Alternativa a Vercel)

Similar a Vercel, excelente para sitios estáticos y frontend.

---

## 🏗️ ARQUITECTURA RECOMENDADA

```
┌─────────────────────────────────────────┐
│         imagemia.com (Vercel)           │
│    Landing page "En Construcción"      │
└─────────────────────────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────┐
│    imagemia.com/empresas (Vercel)       │
│         Página de Login                 │
└─────────────────────────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────┐
│  imagemia.com/empresas/petcimagenes     │
│         (Frontend - Vercel)             │
└─────────────────────────────────────────┘
                    │
                    ↓ (API calls)
┌─────────────────────────────────────────┐
│    api.imagemia.com (Railway)           │
│      Backend Node.js + OpenAI           │
└─────────────────────────────────────────┘
```

---

## 💰 COSTOS ESTIMADOS

### Plan Mínimo (Gratis - Inicio):
- **Vercel**: $0/mes (frontend)
- **Railway**: $5 gratis/mes (backend)
- **Spaceship**: Solo el dominio (~$12/año)
- **Total**: ~$1/mes

### Plan Producción (Recomendado):
- **Vercel Pro**: $20/mes
- **Railway**: $10-20/mes
- **Total**: ~$30-40/mes

---

## 🚀 PLAN DE DESPLIEGUE SUGERIDO

### Fase 1: Landing Page (AHORA)
1. Desplegar `web/imagemia/index.html` en Vercel
2. Conectar dominio `imagemia.com`
3. Configurar SSL automático

### Fase 2: Portal Empresas (ESTA SEMANA)
1. Desplegar `web/empresas/` en Vercel
2. Configurar ruta `/empresas`

### Fase 3: Backend (PRÓXIMA SEMANA)
1. Desplegar backend en Railway
2. Configurar variables de entorno
3. Conectar con frontend

---

## 📝 PRÓXIMO PASO

Elige tu opción de hosting y continúa con:
- `03-DESPLEGAR-EN-VERCEL.md` (Recomendado para empezar)
- `04-DESPLEGAR-EN-RAILWAY.md` (Para el backend)
