-- ============================================
-- SCRIPT DE CONFIGURACIÓN SUPABASE
-- Para sistema de autenticación imagemIA
-- ============================================

-- PASO 1: Crear tabla de perfiles de empresas
-- Esta tabla extiende los usuarios de Supabase con información personalizada

CREATE TABLE public.profiles (
    id UUID REFERENCES auth.users(id) PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    subdomain TEXT NOT NULL,
    nombre_empresa TEXT NOT NULL,
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- PASO 2: Habilitar Row Level Security (RLS)
-- Esto asegura que cada usuario solo vea sus propios datos

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- PASO 3: Políticas de seguridad
-- Los usuarios solo pueden leer su propio perfil

CREATE POLICY "Los usuarios pueden leer su propio perfil"
    ON public.profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Solo admins pueden insertar perfiles (tú desde el dashboard)
CREATE POLICY "Solo admins pueden crear perfiles"
    ON public.profiles
    FOR INSERT
    WITH CHECK (false);

-- Solo admins pueden actualizar perfiles
CREATE POLICY "Solo admins pueden actualizar perfiles"
    ON public.profiles
    FOR UPDATE
    USING (false);

-- PASO 4: Función para auto-crear perfil al registrar usuario
-- Esto crea automáticamente un perfil cuando creas un usuario

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, subdomain, nombre_empresa)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'subdomain', 'default'),
        COALESCE(NEW.raw_user_meta_data->>'nombre_empresa', 'Sin nombre')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- PASO 5: Trigger para ejecutar la función
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- USUARIOS DE EJEMPLO
-- ============================================

-- IMPORTANTE: Primero debes crear los usuarios en Authentication → Users
-- Luego Supabase creará automáticamente sus perfiles

-- Ejemplo de cómo quedaría la tabla:
-- | id (UUID) | email | subdomain | nombre_empresa | activo |
-- |-----------|-------|-----------|----------------|--------|
-- | uuid-1    | petcimagenes@imagemia.com | petcimagenes | PETCIMAGENES | true |
-- | uuid-2    | empresa2@imagemia.com | empresa2 | EMPRESA 2 | true |

-- ============================================
-- CONSULTAS ÚTILES
-- ============================================

-- Ver todos los perfiles
SELECT * FROM public.profiles ORDER BY created_at DESC;

-- Ver perfiles activos
SELECT * FROM public.profiles WHERE activo = true;

-- Buscar por empresa
SELECT * FROM public.profiles WHERE subdomain = 'petcimagenes';

-- Desactivar un usuario (sin eliminarlo)
UPDATE public.profiles SET activo = false WHERE email = 'usuario@ejemplo.com';
