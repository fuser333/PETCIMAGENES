# Guía: Conectar al Hosting Essential de Spaceship

**Fecha:** 24 Octubre 2025
**Plan:** Alojamiento Web Essential
**Dominio:** imagemia.com

---

## 🎯 OBJETIVO

Migrar el sitio de Vercel (gratis) al hosting de Spaceship (que ya pagaste) para no desperdiciar tu inversión.

---

## 📋 PASO 1: OBTENER CREDENCIALES DE cPANEL

### Opción A: Revisar tu email de Spaceship

Busca en tu correo un email de Spaceship con asunto como:
- "Welcome to Spaceship Hosting"
- "Your cPanel Account is Ready"
- "Hosting Account Created"

**El email debe contener:**
- URL de cPanel: https://cpanel.spaceship.com (o similar)
- Usuario de cPanel
- Contraseña temporal
- Servidor/IP del hosting

### Opción B: Desde tu panel de Spaceship

1. Ir a: https://www.spaceship.com
2. Login con tu cuenta
3. Ir a "My Services" o "Hosting"
4. Click en "Alojamiento Web Essential"
5. Buscar botón "**Access cPanel**" o "**Login to cPanel**"
6. O buscar "**View Details**" para ver credenciales

### Opción C: Contactar soporte

Si no encuentras las credenciales:
- Chat en vivo: https://www.spaceship.com/support
- Email: support@spaceship.com
- Pedir: "Necesito credenciales de cPanel para mi plan Essential"

---

## 📋 PASO 2: ACCEDER A cPANEL

Una vez que tengas las credenciales:

1. Abrir: URL de cPanel (ej: https://cpanel.spaceship.com:2083)
2. Ingresar usuario y contraseña
3. Entrarás al panel de control del hosting

---

## 📋 PASO 3: CONFIGURAR EL DOMINIO EN EL HOSTING

### En cPanel, buscar "**Addon Domains**" o "**Dominios**"

**Agregar imagemia.com como dominio principal:**
- Domain: imagemia.com
- Document Root: public_html/imagemia
- FTP username: (se crea automáticamente)

---

## 📋 PASO 4: SUBIR LOS ARCHIVOS DEL SITIO

### Opción A: File Manager (más fácil)

1. En cPanel → "**File Manager**"
2. Navegar a: `public_html/imagemia/`
3. Click derecho → "Upload"
4. Subir los archivos:
   - Toda la carpeta `web/` de tu proyecto

### Estructura a crear:
```
public_html/imagemia/
├── index.html              (de web/imagemia/index.html)
├── assets/
│   └── logos/
│       ├── imagemia-icon.svg
│       ├── imagemia-logo-horizontal.svg
│       └── imagemia-logo-vertical.svg
├── empresas/
│   ├── index.html
│   └── petcimagenes/
│       └── index.html
```

### Opción B: FTP (si prefieres)

**Credenciales FTP:**
- Host: imagemia.com (o IP del servidor)
- Puerto: 21
- Usuario: (de cPanel)
- Contraseña: (de cPanel)

**Cliente FTP recomendado:** FileZilla
- Descargar: https://filezilla-project.org

---

## 📋 PASO 5: CONFIGURAR DNS PARA APUNTAR AL HOSTING

### Obtener la IP del hosting de Spaceship

En cPanel, buscar:
- "**Server Information**" o "**Account Information**"
- Copiar la IP del servidor (ej: 185.x.x.x)

### Cambiar DNS en Spaceship

1. Ir a: https://www.spaceship.com
2. Dominios → imagemia.com → DNS Management
3. **ELIMINAR** los registros actuales de Vercel:
   - A record @ → 76.76.21.21 (ELIMINAR)
   - CNAME www → cname.vercel-dns.com (ELIMINAR)

4. **AGREGAR** nuevos registros para tu hosting:

```
Record 1:
Type: A
Name: @
Value: [IP de tu hosting Spaceship]
TTL: 3600

Record 2:
Type: A
Name: www
Value: [IP de tu hosting Spaceship]
TTL: 3600
```

5. Guardar cambios
6. **Esperar 2-4 horas** para propagación DNS

---

## 📋 PASO 6: CONFIGURAR SSL (HTTPS)

Una vez que el DNS apunte al hosting:

1. En cPanel → "**SSL/TLS Status**"
2. Buscar imagemia.com
3. Click "**Run AutoSSL**"
4. Esperar 5-10 minutos
5. El certificado SSL se instalará automáticamente (Let's Encrypt - gratis)

---

## 📋 PASO 7: PROBAR EL SITIO

Después de 2-4 horas:

1. Abrir: https://imagemia.com
2. Verificar que cargue el sitio (no la página de Vercel)
3. Probar todas las URLs:
   - https://imagemia.com
   - https://imagemia.com/empresas
   - https://imagemia.com/empresas/petcimagenes

---

## 🚨 IMPORTANTE: AJUSTAR RUTAS DE ARCHIVOS

Cuando subas los archivos, debes **ajustar las rutas** porque la estructura cambia:

### En web/imagemia/index.html:
```html
<!-- ANTES (Vercel): -->
<img src="../assets/logos/imagemia-logo-vertical.svg">

<!-- DESPUÉS (cPanel): -->
<img src="assets/logos/imagemia-logo-vertical.svg">
```

### En web/empresas/index.html:
```html
<!-- ANTES (Vercel): -->
<img src="../assets/logos/imagemia-logo-vertical.svg">

<!-- DESPUÉS (cPanel): -->
<img src="../assets/logos/imagemia-logo-vertical.svg">
```

---

## 📊 COMPARACIÓN POST-MIGRACIÓN

| Antes (Vercel) | Después (Spaceship) |
|----------------|---------------------|
| Gratis | ~$1-5 USD/mes |
| Despliegue automático Git | Manual vía FTP/cPanel |
| CDN global | Servidor compartido |
| SSL gratis perpetuo | SSL gratis Let's Encrypt |

---

## 🔄 SIGUIENTE SESIÓN: DESPLEGAR BACKEND

Una vez que el frontend esté en Spaceship, necesitarás:

**Opción A: Backend también en Spaceship**
- Tu plan Essential soporta Node.js/PHP
- Podemos instalar el backend directamente en cPanel

**Opción B: Backend en Railway (recomendado)**
- Frontend en Spaceship
- Backend en Railway (gratis primer mes)
- Mejor escalabilidad

---

## 📞 SI NECESITAS AYUDA

**Spaceship Soporte:**
- Chat: https://www.spaceship.com/support
- Email: support@spaceship.com
- Teléfono: Disponible en su sitio

**Preguntas comunes:**
- "¿Cuál es mi IP del servidor?"
- "¿Cómo accedo a cPanel?"
- "Necesito resetear mi contraseña de cPanel"

---

## ✅ CHECKLIST

- [ ] Obtener credenciales de cPanel
- [ ] Acceder a cPanel exitosamente
- [ ] Agregar imagemia.com como dominio
- [ ] Subir archivos vía File Manager o FTP
- [ ] Ajustar rutas en HTML
- [ ] Cambiar DNS para apuntar a hosting Spaceship
- [ ] Esperar propagación DNS (2-4 horas)
- [ ] Instalar SSL con AutoSSL
- [ ] Probar sitio funcionando en imagemia.com

---

**NOTA:** Una vez que migres a Spaceship hosting, puedes eliminar el proyecto de Vercel si quieres, o dejarlo como respaldo.
