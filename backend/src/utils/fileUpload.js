import OpenAI from 'openai';
import fs from 'fs';
import path from 'path';
import FormData from 'form-data';
import logger from '../config/logger.js';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

// Debug: verificar la estructura del objeto OpenAI
logger.debug(`Propiedades de openai (root): ${Object.keys(openai).filter(k => !k.startsWith('_')).join(', ')}`);
logger.debug(`OpenAI beta existe: ${!!openai.beta}`);
logger.debug(`Propiedades de openai.beta: ${openai.beta ? Object.keys(openai.beta).filter(k => !k.startsWith('_')).join(', ') : 'N/A'}`);
logger.debug(`OpenAI.vectorStores existe (root): ${!!openai.vectorStores}`);
logger.debug(`OpenAI.beta.vectorStores existe: ${!!openai.beta?.vectorStores}`);

/**
 * Sube archivos a OpenAI y retorna los IDs
 */
export async function uploadFilesToOpenAI(files) {
  try {
    const uploadedFiles = [];
    
    for (const file of files) {
      logger.debug(`Subiendo archivo: ${file.originalname}`);
      
      // IMPORTANTE: Crear un archivo con la extensión correcta
      const ext = path.extname(file.originalname);
      const tempPathWithExt = `${file.path}${ext}`;
      
      // Renombrar el archivo temporal para incluir la extensión
      fs.renameSync(file.path, tempPathWithExt);
      
      logger.debug(`Archivo renombrado a: ${tempPathWithExt}`);

      // Leer el archivo como buffer para poder especificar el nombre
      const fileBuffer = fs.readFileSync(tempPathWithExt);

      // Crear un objeto File-like con el nombre original
      const fileBlob = new Blob([fileBuffer]);
      const fileWithName = new File([fileBlob], file.originalname, {
        type: file.mimetype
      });

      // Subir a OpenAI con el nombre original preservado
      const uploadedFile = await openai.files.create({
        file: fileWithName,
        purpose: 'assistants',
      });

      logger.info(`Archivo subido: ${uploadedFile.id} - ${file.originalname}`);
      logger.debug(`Detalles del archivo en OpenAI: filename=${uploadedFile.filename}, bytes=${uploadedFile.bytes}`);
      
      uploadedFiles.push({
        id: uploadedFile.id,
        name: file.originalname,
        size: file.size,
        type: file.mimetype,
      });
      
      // Eliminar el archivo temporal
      fs.unlinkSync(tempPathWithExt);
    }
    
    return uploadedFiles;
  } catch (error) {
    logger.error('Error al subir archivos a OpenAI:', error);
    throw error;
  }
}

/**
 * Sube archivos al vector store de PETCIMAGENES
 */
export async function uploadFilesToVectorStore(files) {
  try {
    const vectorStoreId = process.env.VECTOR_STORE_ID;
    if (!vectorStoreId) {
      throw new Error('VECTOR_STORE_ID no configurado en .env');
    }

    const uploadedFiles = [];
    
    for (const file of files) {
      logger.debug(`Subiendo archivo al vector store: ${file.originalname}`);

      // IMPORTANTE: Crear un archivo con la extensión correcta
      const ext = path.extname(file.originalname);
      const tempPathWithExt = `${file.path}${ext}`;

      // Renombrar el archivo temporal para incluir la extensión
      fs.renameSync(file.path, tempPathWithExt);

      logger.debug(`Archivo renombrado a: ${tempPathWithExt}`);

      // Leer el archivo como buffer para poder especificar el nombre
      const fileBuffer = fs.readFileSync(tempPathWithExt);

      // Crear un objeto File-like con el nombre original
      const fileBlob = new Blob([fileBuffer]);
      const fileWithName = new File([fileBlob], file.originalname, {
        type: file.mimetype
      });

      // Subir a OpenAI con el nombre original preservado
      const uploadedFile = await openai.files.create({
        file: fileWithName,
        purpose: 'assistants',
      });
      
      logger.info(`Archivo subido: ${uploadedFile.id} - ${file.originalname}`);

      // Agregar al vector store (v5 API - vectorStores está en root, no en beta)
      try {
        logger.debug(`Agregando archivo ${uploadedFile.id} al vector store ${vectorStoreId}`);
        const vectorStoreFile = await openai.vectorStores.files.create(
          vectorStoreId,
          { file_id: uploadedFile.id }
        );

        logger.debug(`Respuesta del vector store: ${JSON.stringify(vectorStoreFile)}`);
        logger.info(`Archivo agregado al vector store: ${uploadedFile.id}`);
      } catch (vsError) {
        logger.error(`Error específico al agregar al vector store: ${vsError.message}`);
        logger.error(`Stack trace: ${vsError.stack}`);
        throw vsError;
      }
      
      uploadedFiles.push({
        id: uploadedFile.id,
        name: file.originalname,
        size: file.size,
        type: file.mimetype,
      });

      // Eliminar el archivo temporal
      fs.unlinkSync(tempPathWithExt);
    }
    
    return uploadedFiles;
  } catch (error) {
    logger.error('Error al subir archivos al vector store:', error);
    throw error;
  }
}

/**
 * Elimina archivos de OpenAI
 */
export async function deleteFilesFromOpenAI(fileIds) {
  try {
    for (const fileId of fileIds) {
      await openai.files.del(fileId);
      logger.info(`Archivo eliminado de OpenAI: ${fileId}`);
    }
  } catch (error) {
    logger.error('Error al eliminar archivos de OpenAI:', error);
    throw error;
  }
}
