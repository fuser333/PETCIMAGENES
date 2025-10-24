# 🚀 EJECUTAR TODO AUTOMÁTICAMENTE

## ⚡ OPCIÓN RÁPIDA (TODO EN 1 COMANDO)

Abre tu terminal y ejecuta:

```bash
cd /Users/hbva/AgentkitV1
chmod +x TODO_AUTOMATICO.sh
./TODO_AUTOMATICO.sh
```

Este script hará AUTOMÁTICAMENTE:
1. ✅ Instalar dependencias
2. ✅ Iniciar el backend
3. ✅ Iniciar ngrok
4. ✅ Obtener la URL pública
5. ✅ Actualizar el frontend con la URL
6. ✅ Abrir el navegador con el chat

**¡Y YA ESTÁ! El chat se abrirá solo en tu navegador.**

---

## 🛠️ OPCIÓN MANUAL (Paso a Paso)

### Terminal 1 - Backend:
```bash
cd /Users/hbva/AgentkitV1
chmod +x INICIAR_BACKEND.sh
./INICIAR_BACKEND.sh
```

### Terminal 2 - ngrok:
```bash
cd /Users/hbva/AgentkitV1
chmod +x INICIAR_NGROK.sh
./INICIAR_NGROK.sh
```
📝 **Copia la URL que te da**

### Terminal 3 - Actualizar Frontend:
```bash
cd /Users/hbva/AgentkitV1/frontend
nano app.js
# Cambia: const API_BASE_URL = 'http://localhost:3000';
# Por: const API_BASE_URL = 'TU-URL-DE-NGROK';
# Guarda: Ctrl+O, Enter, Ctrl+X
open index.html
```

---

## 🎯 RECOMENDACIÓN

**USA LA OPCIÓN RÁPIDA** - Es mucho más fácil y hace todo automáticamente.

Si algo falla, revisa los logs:
```bash
tail -f /Users/hbva/AgentkitV1/backend.log
tail -f /Users/hbva/AgentkitV1/ngrok.log
```

---

## 🛑 PARA DETENER TODO

El script te dirá los PIDs al final. Para detener:
```bash
kill [PID_BACKEND] [PID_NGROK]
```

O simplemente cierra las terminales.

---

## ✨ ¡EMPECEMOS!

```bash
cd /Users/hbva/AgentkitV1
chmod +x TODO_AUTOMATICO.sh
./TODO_AUTOMATICO.sh
```

**¡Eso es todo! 🚀**
