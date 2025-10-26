import catchAsync from '../utils/catchAsync.js';
import ApiError from '../utils/ApiError.js';
import agentService from '../services/agentService.vercel.js';

/**
 * Endpoint sin streaming - versión simplificada para Vercel
 * NO soporta uploads de archivos (limitación de Vercel serverless)
 */
export const sendMessage = catchAsync(async (req, res) => {
  const { message, context } = req.body;

  if (!message || !message.trim()) {
    throw new ApiError(400, 'El mensaje es requerido');
  }

  console.log('Procesando mensaje en Vercel');

  // Sin soporte de archivos en Vercel serverless
  const response = await agentService.executeWorkflow(message, context || {}, []);

  res.json({
    success: true,
    data: response
  });
});

/**
 * Endpoint con streaming - versión para Vercel
 */
export const streamMessage = catchAsync(async (req, res) => {
  const { message, context } = req.body;

  if (!message || !message.trim()) {
    throw new ApiError(400, 'El mensaje es requerido');
  }

  // Configura headers para Server-Sent Events
  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    'Connection': 'keep-alive',
    'X-Accel-Buffering': 'no'
  });
  res.flushHeaders();

  try {
    console.log('Iniciando streaming en Vercel');

    // Ejecuta el workflow con streaming (sin archivos)
    const stream = agentService.executeWorkflowStream(message, context || {}, []);

    for await (const event of stream) {
      // Transforma eventos para el frontend
      if (event.type === 'text_delta' && event.content) {
        res.write(`data: ${JSON.stringify({ content: event.content })}\n\n`);
      } else if (event.type === 'done') {
        res.write(`data: [DONE]\n\n`);
      } else if (event.type === 'tool_call') {
        res.write(`data: ${JSON.stringify({
          type: 'status',
          message: `🔧 Usando ${event.tool}...`
        })}\n\n`);
      }
    }

    res.end();

  } catch (error) {
    console.error('Error en streaming:', error);
    res.write(`data: ${JSON.stringify({
      type: 'error',
      message: error.message
    })}\n\n`);
    res.end();
  }

  // Maneja desconexión del cliente
  req.on('close', () => {
    console.log('Cliente desconectado');
    res.end();
  });
});
