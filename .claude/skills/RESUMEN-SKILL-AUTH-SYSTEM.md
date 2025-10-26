# Skill Creada: Imagem.ia Auth System
**Fecha:** 25 de Octubre 2025
**Hora:** ~19:00

## ✅ Skill Completada Exitosamente

Se ha creado y empaquetado la skill **imagemia-auth-system** que proporciona todo lo necesario para implementar autenticación con Supabase en el proyecto Imagem.ia.

## 📦 Ubicación de la Skill

**Skill empaquetada (para compartir)**:
```
/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/.claude/skills/imagemia-auth-system.zip
```

**Skill en desarrollo (editable)**:
```
/Users/hbva/Library/Mobile Documents/com~apple~CloudDocs/MIS EMPRESAS/Imagem.ia/AgentkitV1/.claude/skills/imagemia-auth-system/
```

## 📋 Contenido de la Skill

### 1. SKILL.md
Guía completa que incluye:
- Arquitectura de 3 páginas (Landing → Login → Dashboard)
- Workflow paso a paso para implementación
- Configuración de Supabase
- Seguridad y mejores prácticas
- Testing y troubleshooting
- Organización del proyecto

### 2. Assets (Plantillas)
- `login-template/index.html` - Página de login completa con:
  - Diseño split (info izquierda, form derecha)
  - Integración con Supabase Auth
  - Validación de formularios
  - Manejo de errores
  - Responsive design
  - Colores de Imagem.ia

### 3. References (Documentación)
- `supabase-setup.md` - Guía completa de configuración:
  - Crear proyecto en Supabase
  - Configurar autenticación
  - Gestionar usuarios
  - RLS y seguridad
  - Testing y troubleshooting

- `project-architecture.md` - Arquitectura completa:
  - Diagramas de flujo
  - Estructura de archivos
  - Database schema
  - Deployment architecture
  - Scaling considerations

### 4. Scripts (Automatización)
- `deploy-login-page.sh` - Deploy automático a Spaceship:
  - Pre-flight checks
  - Upload vía FTP
  - Verificación de deployment

- `create-supabase-env.sh` - Configuración de credenciales:
  - Genera archivos .env
  - Actualiza login page con credentials
  - Validaciones de seguridad

## 🎯 Situación Actual

### Lo que YA tienes (descubierto)
El usuario ya tiene una página de login en `/web/empresas/index.html` con:
- ✅ Diseño split con columna verde
- ✅ Logo de Imagem.ia
- ✅ Formulario de email/password
- ✅ Sistema de features
- ✅ Responsive design
- ❌ Autenticación hardcodeada en JavaScript:
  ```javascript
  const empresas = {
      'petcimagenes@imagemia.com': {
          password: 'demo123',
          subdomain: 'petcimagenes'
      }
  };
  ```
- Redirige a: `/empresas/{subdomain}`

### Lo que necesitas hacer
1. **Reemplazar auth hardcodeada con Supabase**
2. **Mantener el flujo de subdominios por empresa**
3. **Conectar con dashboard en localhost:8080**

## 🔗 Arquitectura del Flujo Completo

```
https://imagemia.com
    │
    └─> CTA "Portal de Clientes"
         │
         ▼
https://imagemia.com/empresas (Login Page - VERDE)
    │
    ├─> Panel Izquierdo: Logo + Features
    └─> Panel Derecho: Email + Password
         │
         │ (Supabase Auth)
         ▼
https://imagemia.com/empresas/petcimagenes (Dashboard)
         │
         └─> AgentKit Chat (localhost:8080 → production)
```

## 💡 Próximos Pasos Recomendados

### Paso 1: Configurar Supabase
```bash
# Seguir guía en:
# .claude/skills/imagemia-auth-system/references/supabase-setup.md

1. Crear proyecto en Supabase
2. Configurar Email/Password auth
3. Copiar credenciales (URL + ANON_KEY)
```

### Paso 2: Adaptar tu Login Actual
Tu archivo actual (`/web/empresas/index.html`) necesita:

1. **Agregar Supabase SDK** (antes del `</head>`):
```html
<script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
```

2. **Reemplazar el objeto hardcodeado** (línea 374-381) con:
```javascript
// Configuración de Supabase
const SUPABASE_URL = 'https://xxxxx.supabase.co'
const SUPABASE_ANON_KEY = 'eyJ...'
const supabaseClient = supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// Tabla de subdominios por email (en Supabase profiles)
async function getEmpresaSubdomain(userId) {
    const { data } = await supabaseClient
        .from('profiles')
        .select('subdomain')
        .eq('id', userId)
        .single()
    return data?.subdomain || 'default'
}
```

3. **Actualizar lógica de login** (línea 396-422):
```javascript
loginForm.addEventListener('submit', async function(e) {
    e.preventDefault();

    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    try {
        // Autenticar con Supabase
        const { data, error } = await supabaseClient.auth.signInWithPassword({
            email,
            password
        });

        if (error) throw error;

        // Obtener subdomain de la empresa
        const subdomain = await getEmpresaSubdomain(data.user.id);

        showAlert(`Bienvenido!`, 'success');

        // Redirigir al subdirectorio de la empresa
        setTimeout(() => {
            window.location.href = `/empresas/${subdomain}`;
        }, 1000);

    } catch (error) {
        showAlert(error.message, 'error');
    }
});
```

### Paso 3: Crear Tabla de Perfiles en Supabase
```sql
create table public.profiles (
  id uuid references auth.users on delete cascade not null primary key,
  email text,
  full_name text,
  company_name text,
  subdomain text,  -- ← IMPORTANTE: 'petcimagenes', etc.
  role text default 'client',
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- RLS
alter table public.profiles enable row level security;

create policy "Users can view own profile"
  on public.profiles for select
  using ( auth.uid() = id );
```

### Paso 4: Crear Usuario de Prueba
En Supabase Dashboard → Authentication → Users:
- Email: `petcimagenes@imagemia.com`
- Password: (nueva password segura)
- Luego en Table Editor → profiles:
  - subdomain: `petcimagenes`

### Paso 5: Proteger Dashboard
En `/empresas/petcimagenes/index.html`:
```javascript
// Al inicio de la página
const { data: { session } } = await supabaseClient.auth.getSession()

if (!session) {
    window.location.href = '/empresas'  // Redirigir a login
    return
}

// Usuario autenticado - cargar dashboard
const user = session.user
```

## 📚 Documentación de Referencia

Toda la documentación detallada está en la skill:

1. **Guía principal**: `SKILL.md`
2. **Setup Supabase**: `references/supabase-setup.md`
3. **Arquitectura**: `references/project-architecture.md`
4. **Scripts**: `scripts/` directory

## 🎨 Consideraciones de Diseño

Tu página actual usa colores **VERDE** (#10B981):
```css
background: linear-gradient(135deg, #10B981 0%, #059669 100%);
```

El template que creé usa colores **AZUL** del landing:
```css
--primary: #2563EB;
--accent: #06B6D4;
```

**Recomendación**: Mantén tu diseño verde actual, solo agrega la lógica de Supabase. El verde se ve profesional y ya está optimizado.

## 🔒 Recordatorios de Seguridad

- ✅ Usar SUPABASE_ANON_KEY en frontend (seguro)
- ❌ NUNCA usar SUPABASE_SERVICE_KEY en frontend
- ✅ Habilitar RLS en todas las tablas
- ✅ Usar HTTPS en producción
- ✅ Agregar .env al .gitignore

## 🚀 Comandos Útiles

```bash
# Usar script de configuración
cd .claude/skills/imagemia-auth-system/scripts
./create-supabase-env.sh

# Desplegar login page
./deploy-login-page.sh

# Servir localmente para testing
cd /web/empresas
python3 -m http.server 8888
# Abrir: http://localhost:8888
```

## 📊 Estado del Proyecto

```
✅ Landing page (imagemia.com) - DEPLOYED
✅ Login page design - EXISTS
⏳ Supabase integration - TO DO
⏳ Dashboard protection - TO DO
⏳ Production deployment - TO DO
```

## 🎓 Cómo Usar la Skill

La skill está lista para ser usada por Claude en futuras sesiones. Cuando pidas ayuda con autenticación, Claude podrá:

1. Consultar el SKILL.md para saber qué hacer
2. Usar los templates en assets/
3. Leer las referencias cuando necesite detalles
4. Ejecutar los scripts para deployment

## 💬 Preguntas Frecuentes

**P: ¿Necesito rehacer mi página de login?**
R: No! Tu diseño está perfecto. Solo agrega Supabase al JavaScript existente.

**P: ¿Qué pasa con los usuarios actuales hardcodeados?**
R: Créalos en Supabase con sus mismos emails. Las contraseñas serán nuevas y seguras.

**P: ¿Cómo manejo múltiples empresas?**
R: Cada empresa tiene una fila en la tabla `profiles` con su `subdomain`.

**P: ¿El dashboard debe estar en /empresas/{subdomain}?**
R: Sí, o puedes usar dashboard.imagemia.com con parámetros de empresa.

## 🎉 Logros de Hoy

1. ✅ Creada skill completa de autenticación
2. ✅ Documentación exhaustiva de Supabase
3. ✅ Scripts de deployment automatizados
4. ✅ Template de login page (alternativo al tuyo)
5. ✅ Arquitectura del proyecto completa documentada
6. ✅ Descubierto que ya tienes login page avanzada
7. ✅ Plan claro para integrar Supabase sin perder tu diseño

---

**Próxima sesión:** Implementar Supabase en tu login actual manteniendo el diseño verde! 🚀
