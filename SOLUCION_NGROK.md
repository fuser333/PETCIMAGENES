# 🌐 USAR CON NGROK - SOLUCIÓN AL ERROR

## ❌ EL PROBLEMA

OpenAI solo permite llamadas desde dominios autorizados. 
`localhost:3000` NO está en la lista, por eso falla.

## ✅ LA SOLUCIÓN

Usar **ngrok** para crear un dominio público temporal.

---

## 🚀 PASOS (MUY SIMPLE):

### 1. Instala ngrok (si no lo tienes)

```bash
brew install ngrok
```

O descárgalo de: https://ngrok.com/download

### 2. Ejecuta el script con ngrok

```bash
cd /Users/hbva/AgentkitV1
chmod +x INICIAR_NGROK.sh
./INICIAR_NGROK.sh
```

### 3. Verás algo como esto:

```
✅ ¡TODO LISTO!
==========================================

🌐 TU URL PÚBLICA:
   https://abc123.ngrok-free.app

⚠️  IMPORTANTE:
   1. Ve a: https://platform.openai.com/settings/organization/domains
   2. Agrega este dominio: abc123.ngrok-free.app
   3. Luego abre: https://abc123.ngrok-free.app
```

### 4. Agrega el dominio en OpenAI

1. Ve a: https://platform.openai.com/settings/organization/domains
2. Click en "Add domain"
3. Pega: `abc123.ngrok-free.app` (el que te dio ngrok)
4. Guarda

### 5. Abre la URL de ngrok

Abre `https://abc123.ngrok-free.app` en tu navegador.

**¡Ahora SÍ funcionará!** ✅

---

## 📝 NOTA IMPORTANTE

La URL de ngrok cambia cada vez que reinicias. 

**Opción 1 (Gratis):** Cada vez que reinicies:
- Obtendrás una URL nueva
- Debes agregarla en OpenAI

**Opción 2 (Pago - $8/mes):** 
- Consigue un dominio fijo con ngrok
- Solo configuras una vez

---

## 🎯 ALTERNATIVA: USAR TU DOMINIO EXISTENTE

Si ya tienes este dominio autorizado:
```
https://rosia-unbrocaded-distinguishedly.ngrok-free.dev
```

Y quieres que siempre use ese, necesitas:
1. Tener ngrok con dominio fijo (cuenta paga)
2. O cada vez usar ese dominio específico

---

## 💡 RESUMEN

**El problema NO es tu código**, es que OpenAI requiere dominios autorizados.

**Solución simple:** Usa ngrok y autoriza el dominio que te dé.

**¿Listo para probarlo?** Ejecuta:

```bash
./INICIAR_NGROK.sh
```
