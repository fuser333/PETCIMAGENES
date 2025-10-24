import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import logger from './config/logger.js';
import morganMiddleware from './config/morganMiddleware.js';
import errorHandler from './middleware/errorHandler.js';
import ApiError from './utils/ApiError.js';
import chatRoutes from './routes/chatRoutes.js';

const app = express();

// Habilitar trust proxy para ngrok
app.set('trust proxy', true);

// Seguridad básica - Configuración permisiva para desarrollo
app.use(helmet({
  contentSecurityPolicy: false, // Deshabilitamos CSP para permitir inline scripts
  crossOriginEmbedderPolicy: false
}));

// CORS configurado para permitir todos los orígenes (desarrollo)
const corsOptions = {
  origin: '*', // Permitir todos los orígenes
  credentials: false, // Deshabilitado cuando origin es *
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With']
};
app.use(cors(corsOptions));

// Rate limiting DESHABILITADO en desarrollo
// const limiter = rateLimit({
//   windowMs: 15 * 60 * 1000,
//   max: 100,
//   message: 'Demasiadas requests, intenta más tarde'
// });
// app.use('/api/', limiter);

// Parsing de body
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logging de requests
app.use(morganMiddleware);

// Servir index.html para la ruta raíz
app.get('/', (req, res) => {
  res.sendFile(join(frontendPath, 'index.html'));
});

// Servir archivos estáticos del frontend
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const frontendPath = join(__dirname, '../../frontend');

app.use(express.static(frontendPath));

// Health check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Rutas principales
app.use('/api', chatRoutes);

// Servir index.html para cualquier ruta no API
app.get('*', (req, res, next) => {
  if (req.path.startsWith('/api')) {
    return next();
  }
  res.sendFile(join(frontendPath, 'index.html'));
});

// Manejo de 404 para rutas API
app.use((req, res, next) => {
  if (req.path.startsWith('/api')) {
    next(new ApiError(404, `Ruta ${req.originalUrl} no encontrada`));
  }
});

// Error handler (debe ser el último middleware)
app.use(errorHandler);

export default app;
