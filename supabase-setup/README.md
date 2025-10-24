# 🔐 Configuración de Supabase - PETCIMAGENES

## 📋 Orden de Ejecución

### 1️⃣ Acceder a Supabase Dashboard
- URL: https://supabase.com/dashboard/project/tnohrdssgbnqiohjexfr
- Proyecto: `petcimagenes` (ref: `tnohrdssgbnqiohjexfr`)

### 2️⃣ Ejecutar Scripts SQL

Ve a **SQL Editor** en el panel izquierdo y ejecuta los scripts en este orden:

#### Script 1: Crear Tabla Profiles
```bash
Archivo: 01-create-profiles-table.sql
```
Este script crea:
- ✅ Tabla `profiles` con campos: id, email, full_name, role
- ✅ Índices para búsquedas rápidas
- ✅ Trigger automático para crear perfil cuando se registra usuario
- ✅ Función para actualizar `updated_at`

#### Script 2: Configurar Row Level Security (RLS)
```bash
Archivo: 02-setup-rls-policies.sql
```
Este script configura:
- ✅ RLS habilitado en tabla `profiles`
- ✅ Políticas para que usuarios vean solo su perfil
- ✅ Políticas para que admins vean y gestionen todos los perfiles
- ✅ Función helper `is_admin()`

#### Script 3: Crear Primer Admin
```bash
Archivo: 03-create-first-admin.sql
```
**⚠️ IMPORTANTE**: Antes de ejecutar este script:

1. Ir a **Authentication > Users** en Supabase Dashboard
2. Click en **"Invite User"**
3. Ingresar email del admin (ej: `admin@petcimagenes.com`)
4. Copiar el **UUID** del usuario creado
5. Abrir `03-create-first-admin.sql`
6. Reemplazar `'UUID_DEL_USUARIO_AQUI'` con el UUID real
7. Ejecutar el script

### 3️⃣ Configurar Autenticación

En **Authentication > Settings**:

1. **Email Auth**: Activar "Enable Email Signup"
2. **Email Templates**: Personalizar plantillas de correo (opcional)
3. **URL Configuration**:
   - Site URL: `http://localhost:5173` (desarrollo)
   - Redirect URLs: Agregar `http://localhost:5173/callback`

### 4️⃣ Verificar Configuración

Ejecuta esta consulta en SQL Editor:

```sql
-- Ver todos los perfiles
SELECT id, email, full_name, role, created_at
FROM public.profiles
ORDER BY created_at DESC;

-- Verificar políticas RLS
SELECT tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'profiles';
```

## 🎯 Resultado Esperado

Después de completar estos pasos:

- ✅ Tabla `profiles` creada con RLS habilitado
- ✅ Primer usuario admin configurado
- ✅ Políticas de seguridad aplicadas:
  - Usuarios ven solo su perfil
  - Admins ven y gestionan todos los perfiles
  - Solo admins pueden crear/modificar roles

## 📝 Credenciales del Proyecto

**⚠️ NO compartir públicamente**

```env
VITE_SUPABASE_URL=https://tnohrdssgbnqiohjexfr.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Ya están guardadas en: `/Users/hbva/AgentkitV1/frontend/.env`

## 🔄 Próximos Pasos

Después de configurar Supabase:
1. Crear página de login (`login.html`)
2. Integrar Supabase Auth en el frontend
3. Proteger acceso al chat
4. Crear panel de admin para gestionar usuarios

## 📞 Soporte

Si tienes problemas, verifica:
- ✅ Los scripts se ejecutaron sin errores
- ✅ Las políticas RLS están activas
- ✅ El primer admin tiene el rol correcto
