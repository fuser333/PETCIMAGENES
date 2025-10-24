import express from 'express';
import multer from 'multer';
import { sendMessage, streamMessage, uploadFiles } from '../controllers/chatController.js';

const router = express.Router();

// Configurar multer para manejar uploads
const upload = multer({
  dest: 'uploads/', // Carpeta temporal
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB máximo por archivo
  },
  fileFilter: (req, file, cb) => {
    // Aceptar archivos por extensión (más flexible)
    const allowedExtensions = ['.pdf', '.doc', '.docx', '.txt', '.md', '.xlsx', '.xls', '.csv', '.json', '.png', '.jpg', '.jpeg'];
    const ext = file.originalname.toLowerCase().match(/\.[^.]*$/)?.[0];
    
    if (ext && allowedExtensions.includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error(`Tipo de archivo no permitido: ${file.originalname}`));
    }
  }
});

// POST /api/upload - Subir archivos al vector store
router.post('/upload', upload.array('files', 10), uploadFiles);

// POST /api/chat - Respuesta sin streaming
router.post('/chat', upload.array('files', 10), sendMessage);

// POST /api/chat/stream - Respuesta con streaming (con soporte para archivos)
router.post('/chat/stream', upload.array('files', 10), streamMessage);

export default router;
