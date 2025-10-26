import catchAsync from '../utils/catchAsync.js';
import ApiError from '../utils/ApiError.js';
import agentService from '../services/agentService.optimized.js'; // OPTIMIZADO: Usa versión rápida
import logger from '../config/logger.js';
import { uploadFilesToOpenAI, uploadFilesToVectorStore } from '../utils/fileUpload.js';

/**
 * Endpoint sin streaming - respuesta completa al final
 */
export const sendMessage = catchAsync(async (req, res) => {
  const { message, context } = req.body;
  const files = req.files;
  
  if (!message || !message.trim()) {
    throw new ApiError(400, 'El mensaje es requerido');
  }
  
  logger.info('Procesando mensaje');
  
  // Si hay archivos, subirlos a OpenAI primero
  let fileIds = [];
  if (files && files.length > 0) {
    logger.info(`Subiendo ${files.length} archivo(s)`);
    const uploadedFiles = await uploadFilesToOpenAI(files);
    fileIds = uploadedFiles.map(f => f.id);
  }
  
  const response = await agentService.executeWorkflow(message, context, fileIds);
  
  res.json({
    success: true,
    data: response
  });
});

/**
 * Endpoint con streaming - respuesta en tiempo real
 */
export const streamMessage = catchAsync(async (req, res) => {
  let message = req.body.message;
  const context = req.body.context || {};
  const files = req.files;
  
  // Si hay archivos pero no mensaje, usar un mensaje por defecto
  if (!message && files && files.length > 0) {
    message = 'Analiza estos archivos';
  }
  
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
    logger.info('Iniciando streaming');
    
    // Si hay archivos, subirlos a OpenAI primero
    let fileIds = [];
    if (files && files.length > 0) {
      logger.info(`Subiendo ${files.length} archivo(s)`);
      res.write(`data: ${JSON.stringify({ 
        type: 'status', 
        message: `Subiendo ${files.length} archivo(s)...` 
      })}\n\n`);
      
      const uploadedFiles = await uploadFilesToOpenAI(files);
      fileIds = uploadedFiles.map(f => f.id);
      
      res.write(`data: ${JSON.stringify({ 
        type: 'status', 
        message: 'Archivos subidos correctamente' 
      })}\n\n`);
    }
    
    // Ejecuta el workflow con streaming
    const stream = agentService.executeWorkflowStream(message, context, fileIds);
    
    for await (const event of stream) {
      // Transforma eventos para el frontend
      if (event.type === 'text_delta' && event.content) {
        // Envía solo el contenido de texto
        res.write(`data: ${JSON.stringify({ content: event.content })}\n\n`);
      } else if (event.type === 'done') {
        // Señal de finalización
        res.write(`data: [DONE]\n\n`);
      } else if (event.type === 'tool_call') {
        // Notifica que está usando herramientas
        res.write(`data: ${JSON.stringify({ 
          type: 'status', 
          message: `🔧 Usando ${event.tool}...` 
        })}\n\n`);
      }
    }
    
    res.end();
    
  } catch (error) {
    logger.error('Error en streaming:', error);
    res.write(`data: ${JSON.stringify({ 
      type: 'error', 
      message: error.message 
    })}\n\n`);
    res.end();
  }

  // Maneja desconexión del cliente
  req.on('close', () => {
    logger.debug('Cliente desconectado');
    res.end();
  });
});

/**
 * Endpoint para subir archivos al vector store
 */
export const uploadFiles = catchAsync(async (req, res) => {
  const files = req.files;
  
  if (!files || files.length === 0) {
    throw new ApiError(400, 'No se recibieron archivos');
  }
  
  if (files.length > 10) {
    throw new ApiError(400, 'Máximo 10 archivos permitidos');
  }
  
  logger.info(`Subiendo ${files.length} archivo(s) al vector store`);
  
  const uploadedFiles = await uploadFilesToVectorStore(files);
  
  res.json({
    success: true,
    message: `${files.length} archivo(s) subido(s) correctamente al vector store`,
    files: uploadedFiles
  });
});
