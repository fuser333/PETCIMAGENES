# Guía Completa: Configurar Supabase para imagemIA

Sistema de autenticación para 100+ usuarios de múltiples empresas.

---

## Parte 1: Crear Proyecto en Supabase

### 1.1 Crear cuenta
1. Ve a https://supabase.com
2. Haz clic en "Start your project"
3. Inicia sesión con GitHub o email

### 1.2 Crear proyecto
1. Clic en "New Project"
2. Completa:
   - **Name:** `imagemia-auth`
   - **Database Password:** Genera una segura y guárdala
   - **Region:** South America (São Paulo)
3. Clic en "Create new project" (tarda ~2 minutos)

### 1.3 Obtener credenciales
1. Ve a **Project Settings** (ícono de engranaje)
2. Haz clic en **API**
3. Copia y guarda:
   - **Project URL** (SUPABASE_URL)
   - **anon/public key** (SUPABASE_ANON_KEY)

**Ejemplo:**
```
SUPABASE_URL=https://abcdefgh12345678.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Parte 2: Configurar Base de Datos

### 2.1 Ejecutar script SQL
1. En tu proyecto Supabase, ve a **SQL Editor** (menú lateral)
2. Clic en "+ New query"
3. Copia y pega TODO el contenido de `supabase-setup.sql`
4. Clic en **RUN** (esquina inferior derecha)

**Qué hace este script:**
- Crea tabla `profiles` para info de empresas
- Configura seguridad (RLS)
- Crea trigger para auto-crear perfiles
- Define políticas de acceso

### 2.2 Verificar creación
1. Ve a **Table Editor** (menú lateral)
2. Deberías ver la tabla `profiles` con columnas:
   - id (UUID)
   - email
   - subdomain
   - nombre_empresa
   - activo
   - created_at
   - updated_at

---

## Parte 3: Agregar Usuarios

### 3.1 Crear usuario manualmente (ejemplo)
1. Ve a **Authentication** → **Users**
2. Clic en "+ Add user"
3. Completa:
   - **Email:** petcimagenes@imagemia.com
   - **Password:** demo123 (o la que prefieras)
   - **Auto Confirm User:** ✅ (marcado)
4. Clic en **Create new user**

### 3.2 Agregar metadata del usuario
1. Encuentra el usuario recién creado en la lista
2. Haz clic en él para ver detalles
3. En la sección **User Metadata**, edita el JSON:
```json
{
  "subdomain": "petcimagenes",
  "nombre_empresa": "PETCIMAGENES"
}
```
4. Guarda cambios

### 3.3 Verificar perfil creado
1. Ve a **Table Editor** → **profiles**
2. Deberías ver el perfil del usuario con:
   - email: petcimagenes@imagemia.com
   - subdomain: petcimagenes
   - nombre_empresa: PETCIMAGENES
   - activo: true

---

## Parte 4: Agregar los 100 Usuarios

Tienes 2 opciones:

### Opción A: Manual (recomendado para <20 usuarios)
Repite Parte 3 para cada usuario

### Opción B: Importación Masiva (recomendado para 100 usuarios)

1. Crea un archivo CSV con tus usuarios:
```csv
email,password,subdomain,nombre_empresa
usuario1@empresa1.com,pass1,empresa1,EMPRESA 1
usuario2@empresa2.com,pass2,empresa2,EMPRESA 2
usuario3@empresa3.com,pass3,empresa3,EMPRESA 3
```

2. Usa el script de importación que crearemos juntos

**¿Tienes ya la lista de tus 100 usuarios?** Si me la compartes (email, nombre empresa, subdominio deseado), puedo crear el script de importación.

---

## Parte 5: Actualizar Página de Login

Una vez tengas:
- ✅ Proyecto Supabase creado
- ✅ Script SQL ejecutado
- ✅ Al menos 1 usuario de prueba creado
- ✅ SUPABASE_URL y SUPABASE_ANON_KEY copiadas

Entonces actualizaremos el archivo `/empresas/index.html` con:

1. Reemplazar credenciales:
```javascript
const SUPABASE_URL = 'TU_URL_AQUI'
const SUPABASE_ANON_KEY = 'TU_KEY_AQUI'
```

2. Cambiar a modo producción:
```javascript
const DEV_MODE = false  // ¡Importante!
```

3. Subir archivo actualizado a FTP

---

## Parte 6: Probar Sistema

1. Ve a https://imagemia.com/empresas
2. Ingresa con un usuario de prueba:
   - Email: petcimagenes@imagemia.com
   - Password: demo123
3. Deberías ser redirigido a:
   - http://localhost:8080/empresas/petcimagenes

**Si funciona:** Sistema listo para producción
**Si falla:** Revisa la consola del navegador (F12) para ver errores

---

## Gestión de Usuarios (Post-Implementación)

### Crear nuevo usuario
1. Authentication → Users → Add user
2. Completa email y password
3. Agrega metadata: `{"subdomain": "...", "nombre_empresa": "..."}`

### Desactivar usuario (sin eliminar)
1. Table Editor → profiles
2. Encuentra el usuario
3. Cambia `activo` a `false`

### Cambiar contraseña
1. Authentication → Users
2. Clic en usuario
3. Clic en "Reset password via email"

### Ver usuarios activos
1. Table Editor → profiles
2. Filtra por: `activo = true`

---

## Próximos Pasos

¿Ya creaste tu proyecto en Supabase? Avísame cuando tengas:
- ✅ SUPABASE_URL
- ✅ SUPABASE_ANON_KEY

Y actualizaré el código del login para que funcione en producción.

**¿Necesitas ayuda con algún paso?** Dime en cuál te quedaste.
