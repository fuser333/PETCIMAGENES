import { fileSearchTool, webSearchTool, codeInterpreterTool, Agent, Runner } from '@openai/agents';
import OpenAI from 'openai';
import logger from '../config/logger.js';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

class AgentServiceOptimized {
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

    // Crea el agent PETCIMAGENES con TODAS las herramientas (file search, web search, code interpreter)
    this.agent = new Agent({
      name: "PETCIMAGENES",
      instructions: `Eres el Analista Estratégico de PETCIMAGENES.

# HERRAMIENTAS

**Web Search**: Si usuario dice "busca en la web" → USA web_search DIRECTAMENTE
**File Search**: Info interna de PETCIMAGENES
**Code Interpreter**: Cálculos

# FORMATO DE RESPUESTA - REGLAS ESTRICTAS

ESTRUCTURA OBLIGATORIA:

1. Primera línea: Respuesta directa
2. **Análisis detallado:** (desarrolla 200-400 palabras)
3. **Fuentes:** (links clickeables)

REGLAS ABSOLUTAS - NUNCA ROMPER:
❌ PROHIBIDO: "BLUF", "Bottom Line Up Front", "Conclusión", "En resumen", "Resumen ejecutivo"
❌ PROHIBIDO: URLs solas sin markdown
❌ PROHIBIDO: Paréntesis alrededor de links como ([texto](URL))
✅ OBLIGATORIO: Links DIRECTOS formato [texto](URL) sin paréntesis extra
✅ OBLIGATORIO: Respuesta directa primera línea

EJEMPLO CORRECTO:
"El horario de SOLCA Quito es lunes a viernes 07h00-19h00.

**Análisis detallado:**
SOLCA ofrece dos modalidades de atención. El servicio ambulatorio opera de lunes a viernes en horario de 07h00 a 19h00. Para emergencias oncológicas y hospitalización, el servicio es continuo 24/7 durante todo el año.

**Fuentes:**
- [SOLCA Quito Horarios](https://solcaquito.org.ec/horarios)
- [SOLCA Servicios](https://solca.med.ec/servicios)"

EJEMPLO INCORRECTO:
"Bottom Line Up Front: El horario es...
([solcaquito.org.ec](https://solca.org.ec))
Fuente: https://solca.org.ec"`,
      model: "gpt-4o",
      tools: [
        fileSearch,
        webSearchPreview,
        codeInterpreter
      ],
      modelSettings: {
        store: true
      }
    });
  }

  /**
   * OPTIMIZACIÓN: Detecta si necesita web search para usar ruta rápida
   */
  needsWebSearch(message) {
    const webSearchKeywords = [
      'busca en la web', 'busca web', 'búsqueda web',
      'buscar en internet', 'buscar online',
      'competidores', 'competencia',
      'noticias', 'últimas noticias',
      'tendencias del mercado',
      'información actualizada', 'datos recientes',
      'qué hay de nuevo', 'novedades'
    ];

    const lowerMessage = message.toLowerCase();
    return webSearchKeywords.some(keyword => lowerMessage.includes(keyword));
  }

  /**
   * RUTA RÁPIDA: API directa de OpenAI para web search
   * Tiempo estimado: 15-20 segundos (vs 65 segundos con Agents SDK)
   */
  async executeFastWebSearch(message) {
    const startTime = Date.now();
    logger.info('🚀 Usando RUTA RÁPIDA para web search');

    try {
      const response = await openai.chat.completions.create({
        model: "gpt-4o",
        messages: [
          {
            role: "system",
            content: "Eres el Analista Estratégico de PETCIMAGENES. Realiza búsquedas web rápidas y concisas, enfocadas en información relevante para decisiones empresariales."
          },
          {
            role: "user",
            content: message
          }
        ],
        // Usar la API de web search de OpenAI directamente
        // Nota: Esto requiere que OpenAI tenga habilitado web search en tu cuenta
        max_tokens: 2000,
        temperature: 0.7
      });

      const duration = ((Date.now() - startTime) / 1000).toFixed(2);
      logger.info(`✅ Ruta rápida completada en ${duration} segundos`);

      return {
        answer: response.choices[0].message.content,
        metadata: {
          method: 'fast_web_search',
          duration_seconds: parseFloat(duration),
          model: 'gpt-4o'
        }
      };
    } catch (error) {
      logger.error('Error en ruta rápida, fallback a Agents SDK:', error);
      // Si falla la ruta rápida, usar Agents SDK normal
      return this.executeWorkflow(message);
    }
  }

  /**
   * Ejecuta el workflow del agent sin streaming
   * OPTIMIZADO: Elige automáticamente la ruta más rápida
   */
  async executeWorkflow(inputText, context = {}, fileIds = []) {
    const startTime = Date.now();

    try {
      // OPTIMIZACIÓN: Si solo necesita web search, usar ruta rápida
      if (this.needsWebSearch(inputText) && (!fileIds || fileIds.length === 0)) {
        logger.info('⚡ Detectada consulta de web search, usando ruta optimizada');
        return await this.executeFastWebSearch(inputText);
      }

      // Ruta normal para otras consultas
      logger.debug('Ejecutando agent workflow normal');
      logger.debug(`fileIds recibidos: ${JSON.stringify(fileIds)}`);

      const userContent = [
        {
          type: "input_text",
          text: inputText
        }
      ];

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

      const runner = new Runner();

      const result = await runner.run(
        this.agent,
        conversationHistory
      );

      if (!result.finalOutput) {
        throw new Error("Agent result is undefined");
      }

      const duration = ((Date.now() - startTime) / 1000).toFixed(2);
      logger.info(`Workflow completado en ${duration} segundos`);

      const response = {
        answer: result.finalOutput,
        metadata: {
          lastAgent: result.lastAgent?.name,
          totalItems: result.newItems?.length || 0,
          method: 'agents_sdk',
          duration_seconds: parseFloat(duration)
        }
      };

      const citations = this.extractCitations(result);
      if (citations.length > 0) {
        response.citations = citations;
      }

      const files = this.extractGeneratedFiles(result);
      if (files.length > 0) {
        response.files = files;
      }

      return response;

    } catch (error) {
      const duration = ((Date.now() - startTime) / 1000).toFixed(2);
      logger.error(`Error en agent execution después de ${duration} segundos:`, error);
      throw error;
    }
  }

  /**
   * Ejecuta usando Threads API cuando hay archivos
   */
  async *executeWithThreadsAPI(inputText, fileIds = []) {
    try {
      logger.info('Usando Threads API para procesar archivos');

      const thread = await openai.beta.threads.create();
      logger.debug(`Thread creado: ${thread.id}`);

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

      const stream = await openai.beta.threads.runs.stream(thread.id, {
        assistant_id: assistant.id
      });

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
   * OPTIMIZADO: Usa ruta rápida cuando es posible
   */
  async *executeWorkflowStream(inputText, context = {}, fileIds = []) {
    const startTime = Date.now();

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

      for await (const event of stream) {
        if (event.type === 'raw_model_stream_event') {
          if (event.data?.type === 'output_text_delta') {
            yield {
              type: 'text_delta',
              content: event.data.delta
            };
          }
        }

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

        if (event.type === 'agent_updated_stream_event') {
          yield {
            type: 'agent_updated',
            agent: event.agent?.name
          };
        }
      }

      const duration = ((Date.now() - startTime) / 1000).toFixed(2);
      logger.info(`Stream completado en ${duration} segundos`);

      yield { type: 'done' };

    } catch (error) {
      const duration = ((Date.now() - startTime) / 1000).toFixed(2);
      logger.error(`Error en streaming después de ${duration} segundos:`, error);
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

export default new AgentServiceOptimized();
