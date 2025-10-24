# 🌐 CONFIGURA DNS EN SPACESHIP - PASO FINAL

## ✅ TU SITIO YA ESTÁ DESPLEGADO

**URL temporal de Vercel:** https://imagemia.vercel.app

Ahora solo falta conectar tu dominio `imagemia.com` con Vercel.

---

## 🔧 PASOS EN SPACESHIP

### 1. Ve a Spaceship

1. Abre: https://www.spaceship.com/
2. Inicia sesión
3. Ve a **"My Domains"**
4. Click en **imagemia.com**
5. Click en **"Manage"** o **"DNS"**

---

### 2. Agrega estos DNS Records

#### Record 1: Dominio raíz

```
Type: A
Host: @ (o dejar vacío)
Value: 76.76.21.21
TTL: 3600 (o Auto)
```

#### Record 2: Subdominio WWW

```
Type: CNAME
Host: www
Value: cname.vercel-dns.com
TTL: 3600 (o Auto)
```

---

### 3. Elimina records viejos (si existen)

**IMPORTANTE:** Si hay records A o CNAME viejos apuntando a otro sitio, **elimínalos primero**.

Solo debe haber:
- 1 registro A para `@` apuntando a `76.76.21.21`
- 1 registro CNAME para `www` apuntando a `cname.vercel-dns.com`

---

### 4. Guarda los cambios

Click en **"Save"** o **"Apply Changes"**

---

## ⏳ TIEMPO DE ESPERA

- **Mínimo:** 15 minutos
- **Máximo:** 48 horas
- **Promedio:** 2-4 horas

---

## ✅ VERIFICAR QUE FUNCIONA

Después de 15-30 minutos, verifica:

1. **Abre en navegador:** https://imagemia.com
   - Debería mostrar tu landing page

2. **Verifica SSL:** Debería tener el candado 🔒 (HTTPS)

3. **Verifica redirección:** https://www.imagemia.com
   - Debería redirigir a https://imagemia.com

---

## 🐛 SI NO FUNCIONA

### Verificar propagación DNS:

1. Ve a: https://dnschecker.org
2. Escribe: `imagemia.com`
3. Verifica que aparezca la IP: `76.76.21.21`

### Si la IP es diferente:
- Espera más tiempo (hasta 48 horas)
- Verifica que los DNS en Spaceship sean correctos

### Si después de 48 horas no funciona:
- Revisa que eliminaste los records viejos
- Contacta soporte de Spaceship

---

## 🎉 CUANDO FUNCIONE

Una vez que `imagemia.com` funcione:

1. ✅ Landing page visible
2. ✅ HTTPS automático
3. ✅ `/empresas` funcionando
4. ✅ `/empresas/petcimagenes` funcionando

---

## 📝 URLS FINALES

```
https://imagemia.com                        → Landing page
https://imagemia.com/empresas               → Portal login
https://imagemia.com/empresas/petcimagenes  → AgentKit
```

---

## 🔐 CREDENCIALES DE LOGIN

Para probar el portal de empresas:

```
Email: petcimagenes@imagemia.com
Contraseña: demo123
```

---

**Configura el DNS ahora y avísame cuando esté listo!** 🚀
