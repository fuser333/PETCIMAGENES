# INTEGRACIÓN CON FRONTEND

## URL del Backend en Producción

```
https://petcimagenes-backend.vercel.app
```

## Cambios Necesarios en el Frontend

### 1. Actualizar la URL del API

Busca en tu código del frontend donde se define la URL del backend y cámbiala:

**Antes:**
```javascript
const API_URL = 'http://localhost:3000';
// o
const API_URL = 'https://rosia-unbrocaded-distinguishedly.ngrok-free.dev';
```

**Después:**
```javascript
const API_URL = 'https://petcimagenes-backend.vercel.app';
```

### 2. Endpoints Disponibles

#### Health Check
```javascript
fetch('https://petcimagenes-backend.vercel.app/api/health')
  .then(res => res.json())
  .then(data => console.log(data));
```

#### Chat sin Streaming
```javascript
fetch('https://petcimagenes-backend.vercel.app/api/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    message: '¿Cuáles son las fortalezas de PETCIMAGENES?',
    context: {} // opcional
  })
})
.then(res => res.json())
.then(data => {
  console.log(data.data.answer);
});
```

#### Chat con Streaming (Server-Sent Events)
```javascript
const eventSource = new EventSource(
  'https://petcimagenes-backend.vercel.app/api/chat/stream',
  {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: 'Analiza el FODA de PETCIMAGENES',
      context: {}
    })
  }
);

eventSource.onmessage = (event) => {
  if (event.data === '[DONE]') {
    eventSource.close();
    return;
  }

  const data = JSON.parse(event.data);

  if (data.content) {
    // Agregar el texto incrementalmente
    appendToChat(data.content);
  } else if (data.type === 'status') {
    // Mostrar status (ej: "Usando File Search...")
    showStatus(data.message);
  } else if (data.type === 'error') {
    // Manejar error
    showError(data.message);
  }
};

eventSource.onerror = (error) => {
  console.error('Error en streaming:', error);
  eventSource.close();
};
```

### 3. Ejemplo con Fetch API (sin streaming)

```javascript
async function sendMessage(userMessage) {
  try {
    const response = await fetch('https://petcimagenes-backend.vercel.app/api/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: userMessage
      })
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();

    if (data.success) {
      return data.data.answer;
    } else {
      throw new Error(data.message || 'Error desconocido');
    }
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

// Uso:
sendMessage('¿Qué tecnología tiene PETCIMAGENES?')
  .then(answer => console.log(answer))
  .catch(error => console.error(error));
```

### 4. Ejemplo con Axios

```javascript
import axios from 'axios';

const API_URL = 'https://petcimagenes-backend.vercel.app';

async function sendMessage(message) {
  try {
    const response = await axios.post(`${API_URL}/api/chat`, {
      message: message
    });

    return response.data.data.answer;
  } catch (error) {
    console.error('Error:', error.response?.data || error.message);
    throw error;
  }
}
```

## Diferencias con el Backend Local

### IMPORTANTE: Upload de Archivos

El backend en Vercel **NO soporta upload de archivos** debido a limitaciones de serverless functions (no tienen filesystem persistente).

Si necesitas upload de archivos, tienes dos opciones:

#### Opción A: Usar el backend local
```javascript
// Para desarrollo/testing
const API_URL = 'http://localhost:3000';

// O con ngrok para compartir
const API_URL = 'https://tu-tunnel.ngrok-free.dev';
```

#### Opción B: Implementar Vercel Blob Storage
Requiere modificar el backend para usar Vercel Blob Storage en lugar de filesystem.

### Timeouts

- **Vercel:** Máximo 60 segundos por request
- **Local:** Configurado para 10 minutos

Para consultas muy largas, considera:
1. Usar streaming (más eficiente)
2. Dividir la consulta en partes más pequeñas
3. Usar el backend local para consultas complejas

## Testing

### Test rápido desde la consola del navegador:

```javascript
// Pega esto en la consola de Chrome/Firefox
fetch('https://petcimagenes-backend.vercel.app/api/chat', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ message: 'Hola' })
})
.then(r => r.json())
.then(d => console.log(d.data.answer));
```

### Test de conectividad:

```javascript
fetch('https://petcimagenes-backend.vercel.app/api/health')
  .then(r => r.json())
  .then(d => console.log('Backend status:', d.status));
```

## Variables de Entorno (Frontend)

Si usas variables de entorno en tu frontend:

```env
# .env.local o .env.production
VITE_API_URL=https://petcimagenes-backend.vercel.app
# o
NEXT_PUBLIC_API_URL=https://petcimagenes-backend.vercel.app
# o
REACT_APP_API_URL=https://petcimagenes-backend.vercel.app
```

Y en tu código:
```javascript
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000';
// o
const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';
// o
const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000';
```

## Monitoreo

Para ver logs en tiempo real:
```bash
npx vercel logs petcimagenes-backend --follow
```

O visita el dashboard:
```
https://vercel.com/hector-velascos-projects/petcimagenes-backend
```

## Troubleshooting

### Error de CORS
Si ves errores de CORS en la consola:
- El backend ya tiene CORS habilitado para todos los orígenes (`*`)
- Verifica que estés usando HTTPS (no HTTP mixto)

### Timeout
Si las requests fallan por timeout:
- Usa streaming en lugar de request completa
- Divide consultas largas en partes
- Considera usar el backend local para desarrollo

### 404 Not Found
Verifica que la URL sea correcta:
```
✅ https://petcimagenes-backend.vercel.app/api/chat
❌ https://petcimagenes-backend.vercel.app/chat
```

---

**Backend deployado exitosamente el 26 de Octubre 2025**
