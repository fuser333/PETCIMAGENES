import { fileSearchTool, webSearchTool, codeInterpreterTool, Agent, Runner } from '@openai/agents';
import OpenAI from 'openai';
import logger from '../config/logger.js';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

class AgentService {
  constructor() {
    // Configura las herramientas con tus IDs
    const fileSearch = fileSearchTool([
      "vs_68f4701fe6c881918246bd8e88f0b974"
    ]);
    
    const webSearchPreview = webSearchTool({
      searchContextSize: "medium",
      userLocation: {
        type: "approximate"
      }
    });
    
    const codeInterpreter = codeInterpreterTool({
      container: {
        type: "auto"
      }
    });

    // Crea el agent PETCIMAGENES optimizado con GPT-4o
    this.agent = new Agent({
      name: "PETCIMAGENES",
      instructions: `Instrucciones Mejoradas para el Agente PETCIMAGENES

# 1. IDENTIDAD Y MISIÓN
Tu identidad es Analista Estratégico Principal, un asesor de confianza para la alta dirección de PETCIMAGENES. Tu propósito no es conversar, sino entregar análisis de datos, insights estratégicos y respuestas basadas en evidencia. Eres proactivo, riguroso y tu comunicación es concisa y ejecutiva. Cada respuesta que das debe ser un insumo valioso para la toma de decisiones.

# 2. DIRECTIVA DE PROCESAMIENTO DE CONSULTAS (CICLO COGNITIVO)
Para CADA solicitud, debes ejecutar rigurosamente el siguiente ciclo de tres pasos:

2.1. Deconstrucción de la Solicitud (Análisis de Intención)
Primero, analiza la pregunta para identificar su dominio estratégico. ¿Se refiere a:
Desempeño Interno: Nuestras finanzas, operaciones, capacidades tecnológicas (PET-CT, RM), o cultura organizacional.
Entorno Competitivo: Nuestro posicionamiento frente a competidores clave como SOLCA, SKN Grupo, Alpha Imagen o Medimagenes.
Contexto Macro (PESTEDL): Factores políticos (inestabilidad MSP), económicos (contracción del PIB), tecnológicos (adopción de IA en diagnóstico) o demográficos (envejecimiento de la población en Quito) que nos impactan.
Cumplimiento Normativo: Obligaciones relacionadas con el Decreto Ejecutivo 255 (SST), regulaciones de ARCSA, o el manejo de desechos biomédicos.
Análisis Estratégico: Consultas directas sobre nuestro FODA, las 5 Fuerzas de Porter, o recomendaciones estratégicas.

2.2. Estrategia de Herramientas (Selección de Acción Primaria)
Basado en tu análisis, selecciona la herramienta con la siguiente jerarquía estricta:
ACCIÓN PRIORITARIA: File Search (Base de Conocimiento Interna)
Si la pregunta se relaciona de CUALQUIER forma con PETCIMAGENES o su contexto (los puntos de la sección 2.1), tu primera y obligatoria acción es usar File Search. Esta es tu única fuente de verdad interna. No dudes, no preguntes, no busques en la web. Ejecuta la búsqueda interna primero.

ACCIÓN SECUNDARIA: Web Search (Contexto Externo y Actual)
Úsala SOLAMENTE si la pregunta requiere información muy reciente que no estaría en los documentos estratégicos (ej: "noticias de última hora sobre el MSP", "último dato de inflación del INEC") o si File Search no arroja resultados y la pregunta lo justifica.

ACCIÓN ANALÍTICA: Code Interpreter (Capacidad de Cómputo)
Úsala cuando se te pida explícitamente "calcular", "proyectar", "analizar datos de un archivo", "crear una tabla comparativa" o "generar un gráfico". Esta herramienta procesa datos, no los descubre.

2.3. Orquestación de Herramientas (Para Consultas Complejas)
Para preguntas que requieren múltiples fuentes, debes encadenar las herramientas de forma lógica.
Ejemplo de Flujo: Si se pregunta: "Calcula el impacto en nuestros márgenes si la inflación de insumos importados sube un 5% adicional, y compáralo con la última proyección del PIB de Ecuador."
Paso 1 (File Search): Busca en los documentos internos los datos sobre nuestros márgenes de beneficio y costos de insumos.
Paso 2 (Code Interpreter): Usa los datos obtenidos para calcular el nuevo margen proyectado.
Paso 3 (Web Search): Busca la proyección más reciente del PIB de Ecuador para 2025.
Paso 4 (Síntesis): Integra toda la información en una respuesta ejecutiva.

# 3. PROTOCOLOS DE COMUNICACIÓN Y SALIDA (ESTILO EJECUTIVO)
3.1. Formato de Respuesta (BLUF - Bottom Line Up Front)
Inicia siempre tu respuesta con la conclusión clave o el dato más importante. Luego, desarrolla los detalles y la evidencia que respaldan tu conclusión. Evita preámbulos innecesarios.

3.2. Rigor y Evidencia (Grounding Obligatorio)
TODA afirmación, dato numérico o conclusión cualitativa DEBE estar respaldada por una cita explícita de su fuente. No sintetices información sin atribuirla.
Formato Interno: (Fuente: Documento Interno - Sección X)
Formato Externo: (Fuente: URL de la web)

3.3. Manejo de Incertidumbre y Búsqueda Automática
Cuando File Search no arroja resultados sobre información externa (competidores, mercado, tendencias, datos públicos), regulaciones nuevas, o información actualizada:

Acción OBLIGATORIA: Ejecuta Web Search automáticamente SIN preguntar al usuario.

Pasos a seguir:
1. Si File Search no encuentra la información Y la pregunta es sobre datos externos/públicos → USA WEB SEARCH INMEDIATAMENTE
2. Presenta los resultados de la búsqueda web directamente en tu respuesta
3. Si tampoco encuentras nada en la web, ENTONCES informa que no hay información disponible

PROHIBIDO: Preguntar "¿Quieres que busque en la web?" o "Si lo deseas, puedo buscar...". Simplemente HAZLO.

Ejemplo correcto:
Usuario: "¿Cuáles son los principales competidores en Quito?"
Tú: [Buscas en File Search] → [No encuentras] → [Usas Web Search AUTOMÁTICAMENTE] → Respondes con los resultados

Ejemplo incorrecto:
Usuario: "¿Cuáles son los principales competidores en Quito?"
Tú: "No se encontró información... Si lo deseas, puedo buscar..." ← ESTO ESTÁ MAL

# 4. REGLAS INQUEBRANTABLES (GUARDARRAÍLES)
PROHIBICIÓN DE INCAPACIDAD: NUNCA respondas que "no tienes acceso" a la información interna, a los documentos o al repositorio. Tu identidad asume que tienes acceso total a través de la herramienta File Search. Declarar incapacidad es un fallo crítico de tu función.
MANTENER LA PERSONA: Actúa siempre como un analista estratégico. No uses lenguaje conversacional, emojis, o frases como "espero que esto ayude". Tu comunicación debe ser siempre profesional y directa.
CONFIDENCIALIDAD: No ofrezcas información interna sensible a menos que la pregunta del usuario la solicite directamente. Tu propósito es analizar, no divulgar.`,
      model: "gpt-4o", // Cambiado a GPT-4o para mayor velocidad
      tools: [
        fileSearch,
        webSearchPreview,
        codeInterpreter
      ],
      modelSettings: {
        // Sin reasoning para mayor velocidad
        store: true
      }
    });
  }

  /**
   * Ejecuta el workflow del agent sin streaming
   */
  async executeWorkflow(inputText, context = {}, fileIds = []) {
    try {
      logger.debug('Ejecutando agent workflow');
      logger.debug(`fileIds recibidos: ${JSON.stringify(fileIds)}`);
      
      // Construir el contenido del mensaje del usuario
      const userContent = [
        {
          type: "input_text",
          text: inputText
        }
      ];

      // Si hay archivos, agregarlos como attachments
      if (fileIds && fileIds.length > 0) {
        logger.info(`Agregando ${fileIds.length} archivo(s) como attachments`);
        fileIds.forEach(fileId => {
          if (fileId && typeof fileId === 'string') {
            userContent.push({
              type: "input_file",
              file_id: fileId
            });
            logger.debug(`Archivo agregado: ${fileId}`);
          } else {
            logger.warn(`fileId inválido ignorado: ${fileId}`);
          }
        });
      }
      
      const conversationHistory = [
        {
          role: "user",
          content: userContent
        }
      ];
      
      logger.debug(`conversationHistory: ${JSON.stringify(conversationHistory, null, 2)}`);

      // Runner sin workflow_id específico - deja que el SDK maneje
      const runner = new Runner();

      const result = await runner.run(
        this.agent,
        conversationHistory
      );

      if (!result.finalOutput) {
        throw new Error("Agent result is undefined");
      }

      // Extrae información útil de la respuesta
      const response = {
        answer: result.finalOutput,
        metadata: {
          lastAgent: result.lastAgent?.name,
          totalItems: result.newItems?.length || 0,
        }
      };

      // Extrae citaciones de file_search
      const citations = this.extractCitations(result);
      if (citations.length > 0) {
        response.citations = citations;
      }

      // Extrae archivos generados por code_interpreter
      const files = this.extractGeneratedFiles(result);
      if (files.length > 0) {
        response.files = files;
      }

      return response;
      
    } catch (error) {
      logger.error('Error en agent execution:', error);
      throw error;
    }
  }

  /**
   * Ejecuta usando Threads API cuando hay archivos
   */
  async *executeWithThreadsAPI(inputText, fileIds = []) {
    try {
      logger.info('Usando Threads API para procesar archivos');
      
      // Crear un thread temporal
      const thread = await openai.beta.threads.create();
      logger.debug(`Thread creado: ${thread.id}`);
      
      // Crear el mensaje con archivos adjuntos
      const messageData = {
        role: 'user',
        content: inputText,
        attachments: fileIds.map(fileId => ({
          file_id: fileId,
          tools: [{ type: 'file_search' }, { type: 'code_interpreter' }]
        }))
      };
      
      logger.debug(`Creando mensaje con ${fileIds.length} attachments`);
      await openai.beta.threads.messages.create(thread.id, messageData);
      
      // Crear un assistant si no existe
      const assistant = await openai.beta.assistants.create({
        name: 'PETCIMAGENES',
        instructions: this.agent.instructions,
        model: 'gpt-4o',
        tools: [
          { type: 'file_search' },
          { type: 'code_interpreter' }
        ],
        tool_resources: {
          file_search: {
            vector_store_ids: ['vs_68f4701fe6c881918246bd8e88f0b974']
          }
        }
      });
      
      logger.debug(`Assistant creado: ${assistant.id}`);
      
      // Ejecutar el assistant con streaming
      const stream = await openai.beta.threads.runs.stream(thread.id, {
        assistant_id: assistant.id
      });
      
      // Procesar el stream
      for await (const event of stream) {
        if (event.event === 'thread.message.delta') {
          const delta = event.data.delta.content?.[0];
          if (delta?.type === 'text' && delta.text?.value) {
            yield {
              type: 'text_delta',
              content: delta.text.value
            };
          }
        }
      }
      
      // Limpiar
      await openai.beta.assistants.del(assistant.id);
      await openai.beta.threads.del(thread.id);
      logger.debug('Thread y assistant eliminados');
      
      yield { type: 'done' };
      
    } catch (error) {
      logger.error('Error en Threads API:', error);
      throw error;
    }
  }

  /**
   * Ejecuta el workflow con streaming para respuestas en tiempo real
   */
  async *executeWorkflowStream(inputText, context = {}, fileIds = []) {
    try {
      logger.debug('Ejecutando agent workflow con streaming');
      logger.debug(`fileIds recibidos: ${JSON.stringify(fileIds)}`);
      
      // Si hay archivos, usar Threads API (más estable)
      if (fileIds && fileIds.length > 0) {
        logger.info(`Detectados ${fileIds.length} archivo(s), usando Threads API`);
        yield* this.executeWithThreadsAPI(inputText, fileIds);
        return;
      }
      
      // Sin archivos, usar Agent SDK normal
      logger.info('Sin archivos, usando Agent SDK');
      
      const conversationHistory = [
        {
          role: "user",
          content: inputText
        }
      ];
      
      logger.debug(`conversationHistory: ${JSON.stringify(conversationHistory, null, 2)}`);

      const runner = new Runner();

      const stream = await runner.run(
        this.agent,
        conversationHistory,
        { stream: true }
      );

      // El SDK emite eventos durante la ejecución
      for await (const event of stream) {
        // Eventos de texto token por token
        if (event.type === 'raw_model_stream_event') {
          if (event.data?.type === 'output_text_delta') {
            yield {
              type: 'text_delta',
              content: event.data.delta
            };
          }
        }

        // Eventos de herramientas y acciones
        if (event.type === 'run_item_stream_event') {
          if (event.name === 'tool_called') {
            yield {
              type: 'tool_call',
              tool: event.item?.name,
              status: 'calling'
            };
          }
          
          if (event.name === 'tool_output') {
            yield {
              type: 'tool_result',
              output: event.item?.output
            };
          }
          
          if (event.name === 'message_output_created') {
            yield {
              type: 'message',
              content: event.item
            };
          }
        }

        // Eventos de handoff entre agents
        if (event.type === 'agent_updated_stream_event') {
          yield {
            type: 'agent_updated',
            agent: event.agent?.name
          };
        }
      }

      yield { type: 'done' };
      
    } catch (error) {
      logger.error('Error en streaming:', error);
      throw error;
    }
  }

  /**
   * Extrae citaciones de file_search
   */
  extractCitations(result) {
    const citations = [];
    
    if (!result.newItems) return citations;

    result.newItems
      .filter(item => item.type === 'tool_call_output')
      .forEach(item => {
        if (item.rawItem?.output?.citations) {
          item.rawItem.output.citations.forEach(citation => {
            citations.push({
              text: citation.text || citation.content,
              file_id: citation.file_id,
              url: citation.url
            });
          });
        }
      });
    
    return citations;
  }

  /**
   * Extrae archivos generados por code_interpreter
   */
  extractGeneratedFiles(result) {
    const files = [];
    
    if (!result.newItems) return files;

    result.newItems
      .filter(item => item.type === 'tool_call_output')
      .forEach(item => {
        if (item.rawItem?.output?.files) {
          item.rawItem.output.files.forEach(file => {
            files.push({
              id: file.id,
              name: file.name,
              type: file.type,
              downloadUrl: `/api/files/${file.id}`
            });
          });
        }
      });
    
    return files;
  }
}

export default new AgentService();
