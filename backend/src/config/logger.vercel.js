// Logger simplificado para Vercel (sin filesystem)
const logger = {
  error: (...args) => console.error('[ERROR]', ...args),
  warn: (...args) => console.warn('[WARN]', ...args),
  info: (...args) => console.log('[INFO]', ...args),
  http: (...args) => console.log('[HTTP]', ...args),
  debug: (...args) => {
    if (process.env.NODE_ENV === 'development') {
      console.log('[DEBUG]', ...args);
    }
  }
};

export default logger;
