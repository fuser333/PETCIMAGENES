-- ============================================
-- Crear Perfil para inlliyaku@gmail.com
-- ============================================

-- OPCIÓN 1: Crear perfil automáticamente (recomendado)
-- Este comando busca el ID del usuario y crea el perfil en un solo paso

INSERT INTO public.profiles (id, email, subdomain, nombre_empresa, activo)
SELECT
    id,
    'inlliyaku@gmail.com',
    'petcimagenes',
    'PETCIMAGENES',
    true
FROM auth.users
WHERE email = 'inlliyaku@gmail.com'
ON CONFLICT (id) DO NOTHING;

-- ============================================
-- Verificación: Ver el perfil creado
-- ============================================

SELECT * FROM public.profiles WHERE email = 'inlliyaku@gmail.com';
