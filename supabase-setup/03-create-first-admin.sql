-- =====================================================
-- PETCIMAGENES - Crear Primer Usuario Admin
-- =====================================================
-- Este script debe ejecutarse DESPUÉS de crear el primer usuario
-- manualmente desde el Supabase Dashboard (Authentication > Users > Invite User)
--
-- INSTRUCCIONES:
-- 1. Ir a Supabase Dashboard > Authentication > Users
-- 2. Click en "Invite User"
-- 3. Ingresar email del admin (ejemplo: admin@petcimagenes.com)
-- 4. Copiar el UUID del usuario recién creado
-- 5. Reemplazar 'UUID_DEL_USUARIO_AQUI' abajo con ese UUID
-- 6. Ejecutar este script en SQL Editor
-- =====================================================

-- Reemplazar 'UUID_DEL_USUARIO_AQUI' con el UUID real del usuario
UPDATE public.profiles
SET
    role = 'admin',
    full_name = 'Administrador PETCIMAGENES'
WHERE id = 'UUID_DEL_USUARIO_AQUI';

-- Verificar que se actualizó correctamente
SELECT id, email, full_name, role, created_at
FROM public.profiles
WHERE role = 'admin';
