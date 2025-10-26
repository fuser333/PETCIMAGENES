# 🚀 Configuración imagemIA Multi-Empresa - Paso a Paso

**Fecha:** 25 Octubre 2025
**Proyecto:** imagemIA - Sistema de autenticación multi-empresa
**Dashboard Supabase:** https://supabase.com/dashboard/project/tnohrdssgbnqiohjexfr

---

## ✅ PROGRESO ACTUAL

- [x] Proyecto Supabase creado (ref: tnohrdssgbnqiohjexfr)
- [x] Credenciales configuradas en código
- [x] Página de login actualizada con Supabase
- [x] DEV_MODE cambiado a `false` (producción activa)
- [ ] **PENDIENTE:** Renombrar proyecto a "imagemia"
- [ ] **PENDIENTE:** Ejecutar script SQL multi-empresa
- [ ] **PENDIENTE:** Crear primer usuario (PETCIMAGENES)
- [ ] **PENDIENTE:** Subir página a producción

---

## PASO 1: Renombrar Proyecto de Supabase

### Por qué es importante
El proyecto actualmente se llama "petcimagenes" pero debería llamarse "imagemia" porque:
- imagemIA es la plataforma completa
- PETCIMAGENES es solo UNA de las ~100 empresas
- Claridad para gestión futura

### Instrucciones

1. **Accede al dashboard:**
   ```
   https://supabase.com/dashboard/project/tnohrdssgbnqiohjexfr
   ```

2. **Ve a Settings (Configuración):**
   - Haz clic en el ícono de engranaje ⚙️ en el menú lateral
   - Selecciona **"General"**

3. **Renombra el proyecto:**
   - Busca el campo **"Name"** o **"Project name"**
   - Cambia de: `petcimagenes`
   - A: `imagemia`
   - Haz clic en **"Save"** o **"Update"**

### ⚠️ IMPORTANTE
- **NO cambiará** la URL (sigue siendo tnohrdssgbnqiohjexfr.supabase.co)
- **NO cambiará** el API key
- Solo cambia el nombre visual del proyecto en el dashboard

### ✅ Verificación
- El nombre del proyecto debe aparecer como "imagemia" en el menú superior del dashboard

---

## PASO 2: Ejecutar Script SQL Multi-Empresa

### Qué hace este script
Crea la estructura de base de datos para manejar múltiples empresas:
- Tabla `profiles` con campos: subdomain, nombre_empresa
- Políticas de seguridad (RLS)
- Triggers automáticos para nuevos usuarios

### Instrucciones

1. **Abre SQL Editor:**
   ```
   https://supabase.com/dashboard/project/tnohrdssgbnqiohjexfr/sql/new
   ```

2. **Copia el script completo:**
   - Abre el archivo: `web/deploy/supabase-setup.sql`
   - Selecciona TODO el contenido (Cmd+A / Ctrl+A)
   - Copia (Cmd+C / Ctrl+C)

3. **Pega en SQL Editor:**
   - Pega el contenido en el editor de Supabase
   - Verifica que se vea completo (95 líneas aprox)

4. **Ejecuta el script:**
   - Haz clic en **"RUN"** (botón azul esquina inferior derecha)
   - Espera confirmación (aparecerá "Success" o mensaje verde)

### ✅ Verificación
1. Ve a **Table Editor** (menú lateral)
2. Deberías ver la tabla **"profiles"** con columnas:
   - id (uuid)
   - email (text)
   - subdomain (text)
   - nombre_empresa (text)
   - activo (boolean)
   - created_at (timestamptz)
   - updated_at (timestamptz)

---

## PASO 3: Crear Primer Usuario (PETCIMAGENES)

### Por qué PETCIMAGENES primero
Es el cliente actual que ya está usando el sistema. Será la primera empresa en el sistema multi-empresa.

### Instrucciones

1. **Accede a Authentication:**
   ```
   https://supabase.com/dashboard/project/tnohrdssgbnqiohjexfr/auth/users
   ```

2. **Crea nuevo usuario:**
   - Haz clic en **"Add user"** o **"Invite user"**
   - Selecciona **"Create new user"**

3. **Completa el formulario:**
   ```
   Email: petcimagenes@imagemia.com
   Password: [DEFINE UNA SEGURA - GUARDARLA]
   Auto Confirm User: ✅ (marcado)
   ```

4. **Agrega User Metadata (MUY IMPORTANTE):**
   - Busca la sección **"User Metadata"** o **"Raw User Meta Data"**
   - Pega este JSON:
   ```json
   {
     "subdomain": "petcimagenes",
     "nombre_empresa": "PETCIMAGENES"
   }
   ```
   - Esto es CRÍTICO para que el sistema sepa a qué empresa pertenece

5. **Guarda el usuario:**
   - Haz clic en **"Create user"** o **"Save"**

### ✅ Verificación
1. Ve a **Table Editor** → **profiles**
2. Deberías ver un registro con:
   - email: `petcimagenes@imagemia.com`
   - subdomain: `petcimagenes`
   - nombre_empresa: `PETCIMAGENES`
   - activo: `true`

Si NO aparece:
- Verifica que ejecutaste el script SQL del Paso 2
- El trigger debería crear automáticamente el perfil

---

## PASO 4: Subir Página Actualizada a Producción

### Qué vamos a subir
La página `/web/deploy/empresas/index.html` ya actualizada con:
- ✅ Credenciales de Supabase configuradas
- ✅ DEV_MODE = false (producción)
- ✅ Lógica multi-empresa lista

### Instrucciones

1. **Sube vía FTP:**
   ```bash
   cd /Users/hbva/Library/Mobile\ Documents/com~apple~CloudDocs/MIS\ EMPRESAS/Imagem.ia/AgentkitV1/web/deploy

   lftp -c "
   set ftp:ssl-allow no
   open ftp://imagemiadeploy@imagemia.com:zydGeb-jajrec-3fipgu@ftp.imagemia.com
   cd ..
   cd imagemia.com
   cd empresas
   lcd empresas
   put index.html
   ls -la index.html
   bye
   "
   ```

2. **Verifica subida exitosa:**
   - Deberías ver el archivo `index.html` en el listado
   - Tamaño esperado: ~26KB

### ✅ Verificación Final
1. Abre en navegador: **https://imagemia.com/empresas**
2. Deberías ver la página de login
3. **Prueba de login:**
   - Email: `petcimagenes@imagemia.com`
   - Password: [la que definiste en Paso 3]
   - Al hacer login, debería redirigir a:
     ```
     http://localhost:8080/empresas/petcimagenes
     ```
     (o tu dominio de producción si lo configuraste)

---

## 🎉 SISTEMA COMPLETO

Si todo funciona correctamente:

### Lo que tienes ahora:
- ✅ Proyecto "imagemia" en Supabase
- ✅ Sistema multi-empresa funcionando
- ✅ PETCIMAGENES como primera empresa
- ✅ Login en producción (imagemia.com/empresas)
- ✅ Redirección a subdomain correcto

### Próximos pasos:
1. **Agregar más empresas:**
   - Repite Paso 3 para cada nueva empresa
   - Solo cambia: email, subdomain, nombre_empresa

2. **Importación masiva (para ~100 usuarios):**
   - Usa el script `web/deploy/importar-usuarios.js`
   - Crea archivo `usuarios.json` con todos los datos
   - Ejecuta: `node importar-usuarios.js`

3. **Configurar dominio de producción:**
   - Reemplazar `localhost:8080` con tu dominio real
   - Actualizar en la función de redirección

---

## 📞 Soporte

Si algo falla:
1. Revisa la consola del navegador (F12)
2. Verifica que el SQL se ejecutó correctamente
3. Confirma que el usuario tiene metadata correcta
4. Valida que DEV_MODE = false

**Dashboard Supabase:** https://supabase.com/dashboard/project/tnohrdssgbnqiohjexfr
