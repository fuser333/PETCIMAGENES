# 🎉 NUEVA VERSIÓN CON DOS SISTEMAS DE ARCHIVOS

## ✅ LO QUE SE AGREGÓ:

### 1️⃣ SIDEBAR IZQUIERDA (Vector Store - Permanente)
```
📚 BASE DE CONOCIMIENTO (VECTOR STORE)
┌────────────────────────────────┐
│ 📂 Seleccionar Archivos        │ ← Click para elegir
├────────────────────────────────┤
│ ⬆️  Enviar al Vector Store      │ ← Click para SUBIR
├────────────────────────────────┤
│ Archivos seleccionados:        │
│  📄 manual.pdf (2.3 MB)    [×] │
│  📊 reporte.xlsx (512 KB)  [×] │
└────────────────────────────────┘
```

**Flujo:**
1. Click "📂 Seleccionar Archivos"
2. Elegir archivos (máx. 10)
3. Ver lista con botón [×] para eliminar
4. Click "⬆️ Enviar al Vector Store" (botón VERDE)
5. Archivos se suben permanentemente

### 2️⃣ CHAT DERECHA (Archivos Temporales)
```
┌─────────────────────────────────────┐
│ Chat Area                           │
│                                     │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│ 📎 archivo.pdf (1.2 MB)    [×]     │ ← Preview
├─────────────────────────────────────┤
│ 📎 | [  Escribe mensaje...  ] ✉️  │
│ ↑                                   │
│ Click aquí para adjuntar            │
└─────────────────────────────────────┘
```

**Flujo:**
1. Click en botón "📎" junto al input
2. Elegir archivos
3. Ver preview arriba del input
4. Escribir mensaje (opcional)
5. Click "Enviar ✉️"
6. Archivos se envían CON el mensaje para análisis temporal

---

## 🚀 CÓMO ACTIVAR LA NUEVA VERSIÓN:

### Opción 1: Reemplazar Manualmente
```bash
cd /Users/hbva/AgentkitV1/frontend
mv index.html index_old.html
mv index_v2.html index.html
```

### Opción 2: Usar el Archivo Nuevo Directamente
El nuevo archivo está en:
```
/Users/hbva/AgentkitV1/frontend/index_v2.html
```

Para activarlo, copia y pega este comando en tu terminal:

```bash
cd /Users/hbva/AgentkitV1/frontend && mv index.html index_backup_$(date +%Y%m%d_%H%M%S).html && cp index_v2.html index.html && echo "✅ Nueva versión activada"
```

---

## 🔄 LUEGO RECARGA EL NAVEGADOR:

1. **Cierra TODAS las pestañas** de la app
2. Abre **nueva ventana incógnito**
3. Ve a: `https://rosia-unbrocaded-distinguishedly.ngrok-free.dev`
4. Presiona **Cmd + Shift + R**

---

## 📸 LO QUE VERÁS:

```
┌──────────────────────────────────────────────────────┐
│ 🔵 P  PETCIMAGENES                                   │
└──────────────────────────────────────────────────────┘
┌─────────────────┬────────────────────────────────────┐
│ 📚 BASE DE      │                                    │
│ CONOCIMIENTO    │                                    │
│                 │         Chat Area                  │
│ 📂 Seleccionar  │                                    │
│ Archivos        │                                    │
│                 │                                    │
│ ⬆️ Enviar al     │                                    │
│ Vector Store    │                                    │
│ (BOTÓN VERDE)   │                                    │
│                 │                                    │
│ Lista de        │                                    │
│ archivos        │                                    │
│                 ├────────────────────────────────────┤
│                 │ Preview de attachments (si hay)    │
│                 ├────────────────────────────────────┤
│                 │ 📎 | [  Mensaje...  ] | Enviar ✉️  │
└─────────────────┴────────────────────────────────────┘
         ↑                           ↑
    Permanente                   Temporal
    (Vector Store)              (Por mensaje)
```

---

## 🎯 DIFERENCIAS CLAVE:

| Aspecto | Vector Store (Izquierda) | Chat Attachments (Derecha) |
|---------|-------------------------|----------------------------|
| **Propósito** | Documentos permanentes de la empresa | Análisis temporal de archivos |
| **Duración** | Permanente, siempre disponible | Solo para ese mensaje |
| **Ubicación** | Sidebar izquierda | Junto al input del chat |
| **Botón** | "📂 Seleccionar" + "⬆️ Enviar" | "📎" (clip) |
| **Color** | Verde (botón Enviar) | Gris (botón clip) |
| **Ejemplo** | Manual de marca, organigrama | PDF temporal para revisar |

---

## ✅ PRUEBA AMBOS SISTEMAS:

### Test 1: Vector Store (Permanente)
1. Click "📂 Seleccionar Archivos" (sidebar)
2. Elige "manual_marca.pdf"
3. Click "⬆️ Enviar al Vector Store" (VERDE)
4. Espera confirmación: "✅ 1 archivo(s) subido(s) permanentemente"
5. Pregunta: "¿Qué dice el manual de marca sobre los colores?"

### Test 2: Chat Attachment (Temporal)
1. Click "📎" (junto al input)
2. Elige "factura.pdf"
3. Escribe: "Analiza esta factura"
4. Click "Enviar ✉️"
5. El AI analiza el archivo temporal

---

**¿Listo para activar la nueva versión?** Copia el comando de arriba en tu terminal! 🚀
