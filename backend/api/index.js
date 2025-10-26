// Vercel serverless function handler
import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import { sendMessage, streamMessage } from '../src/controllers/chatController.vercel.js';
import catchAsync from '../src/utils/catchAsync.js';
import ApiError from '../src/utils/ApiError.js';

const app = express();

// CORS para permitir todos los orígenes
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

// Parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    env: {
      hasOpenAIKey: !!process.env.OPENAI_API_KEY,
      nodeEnv: process.env.NODE_ENV
    }
  });
});

// Chat endpoint sin streaming (mejor para Vercel)
app.post('/api/chat', catchAsync(sendMessage));

// Streaming endpoint (puede tener problemas en Vercel)
app.post('/api/chat/stream', catchAsync(streamMessage));

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not found',
    path: req.path
  });
});

// Error handler
app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    message: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// Export para Vercel
export default app;
