import app from './app.js';
import logger from './config/logger.js';

const PORT = process.env.PORT || 3000;

// Función para inicializar ngrok
async function setupNgrok(port) {
  if (process.env.USE_NGROK !== 'true' || process.env.NODE_ENV === 'production') {
    return;
  }

  try {
    const ngrok = (await import('ngrok')).default;
    
    const url = await ngrok.connect({
      proto: 'http',
      addr: port,
      authtoken: process.env.NGROK_AUTH_TOKEN,
      domain: process.env.NGROK_DOMAIN, // Opcional: solo con plan pago
    });
    
    logger.info(`🌐 Túnel ngrok abierto: ${url}`);
    logger.info(`🔗 URL pública: ${url}/api/chat`);
    logger.info(`📊 Dashboard ngrok: http://localhost:4040`);
    
  } catch (error) {
    logger.error('Error iniciando ngrok:', error.message);
  }
}

// Inicia el servidor
async function startServer() {
  const server = app.listen(PORT, () => {
    logger.info(`✅ Servidor corriendo en puerto ${PORT}`);
    logger.info(`📍 Modo: ${process.env.NODE_ENV || 'development'}`);
    logger.info(`🔗 Local: http://localhost:${PORT}`);
  });

  // Aumentar timeout para requests largos (agents pueden tomar tiempo)
  server.timeout = 600000; // 10 minutos
  server.keepAliveTimeout = 610000;
  server.headersTimeout = 620000;

  // Configura ngrok si está habilitado
  await setupNgrok(PORT);

  // Graceful shutdown
  const shutdown = () => {
    logger.info('Cerrando servidor...');
    server.close(() => {
      logger.info('Servidor cerrado');
      process.exit(0);
    });
  };

  process.on('SIGTERM', shutdown);
  process.on('SIGINT', shutdown);
}

// Verifica API key antes de iniciar
if (!process.env.OPENAI_API_KEY) {
  logger.error('❌ ERROR: OPENAI_API_KEY es requerida');
  process.exit(1);
}

startServer();
