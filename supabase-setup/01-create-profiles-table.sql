-- =====================================================
-- PETCIMAGENES - Tabla de Perfiles de Usuario
-- =====================================================
-- Este script crea la tabla profiles con roles (admin/user)
-- Ejecutar en: Supabase Dashboard > SQL Editor

-- Crear tabla profiles
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('admin', 'user')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Crear índice en email para búsquedas rápidas
CREATE INDEX IF NOT EXISTS idx_profiles_email ON public.profiles(email);

-- Crear índice en role para filtrar por tipo de usuario
CREATE INDEX IF NOT EXISTS idx_profiles_role ON public.profiles(role);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar updated_at
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Función para crear perfil automáticamente cuando se registra un usuario
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name, role)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'Usuario'),
        COALESCE(NEW.raw_user_meta_data->>'role', 'user')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger para crear perfil automáticamente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- Comentarios para documentación
COMMENT ON TABLE public.profiles IS 'Perfiles de usuario con roles (admin/user) para PETCIMAGENES';
COMMENT ON COLUMN public.profiles.id IS 'UUID del usuario (referencia a auth.users)';
COMMENT ON COLUMN public.profiles.email IS 'Email del usuario';
COMMENT ON COLUMN public.profiles.full_name IS 'Nombre completo del usuario';
COMMENT ON COLUMN public.profiles.role IS 'Rol del usuario: admin o user';
