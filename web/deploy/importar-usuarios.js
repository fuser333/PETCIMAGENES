/**
 * Script de importación masiva de usuarios a Supabase
 * Para sistema imagemIA
 *
 * INSTRUCCIONES:
 * 1. Crea archivo 'usuarios.json' con la estructura mostrada abajo
 * 2. Instala Supabase CLI: npm install -g @supabase/supabase-js
 * 3. Ejecuta: node importar-usuarios.js
 */

// ============================================
// CONFIGURACIÓN
// ============================================

// Reemplaza con tus credenciales de Supabase
const SUPABASE_URL = 'TU_SUPABASE_URL_AQUI'
const SUPABASE_SERVICE_KEY = 'TU_SERVICE_ROLE_KEY_AQUI' // ⚠️ NO uses anon key, usa service_role key

// ============================================
// ESTRUCTURA DEL ARCHIVO usuarios.json
// ============================================
/*
[
  {
    "email": "petcimagenes@imagemia.com",
    "password": "demo123",
    "subdomain": "petcimagenes",
    "nombre_empresa": "PETCIMAGENES"
  },
  {
    "email": "empresa2@imagemia.com",
    "password": "pass456",
    "subdomain": "empresa2",
    "nombre_empresa": "EMPRESA 2"
  }
]
*/

// ============================================
// CÓDIGO DE IMPORTACIÓN
// ============================================

const { createClient } = require('@supabase/supabase-js')
const fs = require('fs')
const path = require('path')

// Validar configuración
if (SUPABASE_URL === 'TU_SUPABASE_URL_AQUI' || SUPABASE_SERVICE_KEY === 'TU_SERVICE_ROLE_KEY_AQUI') {
    console.error('❌ ERROR: Debes configurar SUPABASE_URL y SUPABASE_SERVICE_KEY')
    console.log('📖 Las encuentras en: Project Settings → API')
    console.log('   - Project URL')
    console.log('   - service_role key (¡NO anon key!)')
    process.exit(1)
}

// Inicializar cliente con service_role (admin)
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_KEY, {
    auth: {
        autoRefreshToken: false,
        persistSession: false
    }
})

// Cargar archivo de usuarios
const usuariosPath = path.join(__dirname, 'usuarios.json')

if (!fs.existsSync(usuariosPath)) {
    console.error('❌ ERROR: No se encuentra el archivo usuarios.json')
    console.log('📝 Crea el archivo con la estructura indicada en este script')
    process.exit(1)
}

const usuarios = JSON.parse(fs.readFileSync(usuariosPath, 'utf-8'))

console.log(`📊 Se importarán ${usuarios.length} usuarios\n`)

// Función para importar un usuario
async function importarUsuario(usuario) {
    const { email, password, subdomain, nombre_empresa } = usuario

    try {
        // 1. Crear usuario en Authentication
        const { data: authData, error: authError } = await supabase.auth.admin.createUser({
            email,
            password,
            email_confirm: true, // Auto-confirmar email
            user_metadata: {
                subdomain,
                nombre_empresa
            }
        })

        if (authError) {
            throw authError
        }

        console.log(`✅ ${email} → Creado exitosamente`)

        return { success: true, email }

    } catch (error) {
        console.error(`❌ ${email} → Error: ${error.message}`)
        return { success: false, email, error: error.message }
    }
}

// Función principal
async function main() {
    console.log('🚀 Iniciando importación...\n')

    const resultados = {
        exitosos: 0,
        fallidos: 0,
        errores: []
    }

    // Importar usuarios de forma secuencial (evitar rate limits)
    for (const usuario of usuarios) {
        const resultado = await importarUsuario(usuario)

        if (resultado.success) {
            resultados.exitosos++
        } else {
            resultados.fallidos++
            resultados.errores.push(resultado)
        }

        // Pausa de 500ms entre requests (evitar rate limiting)
        await new Promise(resolve => setTimeout(resolve, 500))
    }

    // Reporte final
    console.log('\n' + '='.repeat(50))
    console.log('📊 REPORTE FINAL')
    console.log('='.repeat(50))
    console.log(`✅ Exitosos: ${resultados.exitosos}`)
    console.log(`❌ Fallidos: ${resultados.fallidos}`)
    console.log(`📁 Total: ${usuarios.length}`)

    if (resultados.errores.length > 0) {
        console.log('\n⚠️  ERRORES ENCONTRADOS:')
        resultados.errores.forEach(err => {
            console.log(`   - ${err.email}: ${err.error}`)
        })
    }

    console.log('\n✨ Importación completada!')
    console.log('🔍 Verifica en: Supabase Dashboard → Authentication → Users')
}

// Ejecutar
main().catch(error => {
    console.error('❌ Error fatal:', error)
    process.exit(1)
})
