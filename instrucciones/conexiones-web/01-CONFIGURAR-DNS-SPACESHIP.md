# 🌐 CONFIGURACIÓN DNS EN SPACESHIP

## Paso 1: Acceder al Panel de Spaceship

1. Ir a: https://www.spaceship.com/
2. Iniciar sesión con tus credenciales
3. Ir a **"My Domains"** (Mis Dominios)
4. Seleccionar tu dominio: **imagemia.com**

---

## Paso 2: Configurar DNS Records

En la sección de DNS Management, necesitas agregar los siguientes registros:

### A) Registro A (Dominio Principal)

```
Type: A
Host: @
Value: [IP-DE-TU-SERVIDOR]
TTL: 3600
```

Este apunta `imagemia.com` a tu servidor.

### B) Registro CNAME para WWW

```
Type: CNAME
Host: www
Value: imagemia.com
TTL: 3600
```

Este hace que `www.imagemia.com` redirija a `imagemia.com`.

### C) Registro A para Subdominios (opcional)

Si quieres usar subdominios separados:

```
Type: A
Host: empresas
Value: [IP-DE-TU-SERVIDOR]
TTL: 3600
```

---

## Paso 3: Configurar SSL (HTTPS)

Spaceship generalmente ofrece SSL gratuito con Let's Encrypt:

1. En el panel de tu dominio, buscar **"SSL Certificate"**
2. Activar **"Auto SSL"** o **"Let's Encrypt"**
3. Esperar 5-15 minutos para que se active

---

## Paso 4: Verificar Propagación DNS

Los cambios DNS pueden tardar entre 1-48 horas en propagarse completamente.

Para verificar:

```bash
# Verificar si el dominio apunta correctamente
dig imagemia.com

# O usar una herramienta online:
# https://www.whatsmydns.net/
```

---

## 📝 NOTAS IMPORTANTES

1. **Tiempo de propagación**: Puede tardar hasta 48 horas
2. **Caché DNS**: Limpia tu caché DNS local si no ves cambios:
   ```bash
   # En Mac:
   sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
   ```
3. **Backup**: Guarda los DNS records anteriores antes de hacer cambios

---

## ⚠️ PRÓXIMO PASO

Una vez configurado el DNS, continúa con:
- `02-CONFIGURAR-HOSTING-SPACESHIP.md`
