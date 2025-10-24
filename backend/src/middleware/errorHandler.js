import logger from '../config/logger.js';

const errorHandler = (err, req, res, next) => {
  let { statusCode, message } = err;
  
  // Errores específicos del Agent SDK
  if (err.name === 'MaxTurnsExceededError') {
    statusCode = 429;
    message = 'El agente no pudo completar la tarea en el límite de iteraciones';
  }
  
  if (err.name === 'ModelBehaviorError') {
    statusCode = 500;
    message = 'El modelo produjo una respuesta inesperada';
  }
  
  if (err.name === 'GuardrailTripwireTriggered') {
    statusCode = 400;
    message = 'La solicitud fue bloqueada por las verificaciones de seguridad';
  }
  
  // Log del error
  if (process.env.NODE_ENV !== 'production') {
    logger.error(err);
  }
  
  res.status(statusCode || 500).json({
    success: false,
    message: process.env.NODE_ENV === 'production' && !err.isOperational
      ? 'Error interno del servidor'
      : message,
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack })
  });
};

export default errorHandler;
