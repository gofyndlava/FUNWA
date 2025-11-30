const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const session = require('express-session');
const { exec } = require('child_process');
const util = require('util');
const execPromise = util.promisify(exec);
require('dotenv').config();

const authRoutes = require('./routes/auth');
const spiRoutes = require('./routes/spi');
const stencilRoutes = require('./routes/stencil');
const sqgRoutes = require('./routes/sqg');
const waveRoutes = require('./routes/wave');
const scrapRoutes = require('./routes/scrap');

const app = express();
const PORT = process.env.PORT || 5001;

// Middleware
app.use(cors({
  origin: process.env.CLIENT_URL || 'http://localhost:3000',
  credentials: true
}));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Session configuration
app.use(session({
  secret: process.env.SESSION_SECRET || 'factory-utility-session-secret',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: process.env.NODE_ENV === 'production',
    httpOnly: true,
    maxAge: 8 * 60 * 60 * 1000 // 8 hours
  }
}));

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', message: 'Factory Utility API is running', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/spi', spiRoutes);
app.use('/api/stencil', stencilRoutes);
app.use('/api/sqg', sqgRoutes);
app.use('/api/wave', waveRoutes);
app.use('/api/scrap', scrapRoutes);

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: err.message || 'Internal server error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// Function to kill process on port
async function killProcessOnPort(port) {
  try {
    const { stdout } = await execPromise(`lsof -ti:${port} 2>/dev/null || echo ""`);
    const pid = stdout.trim();
    if (pid) {
      try {
        await execPromise(`kill -9 ${pid}`);
        console.log(`🔄 Killed process ${pid} on port ${port}`);
        await new Promise(resolve => setTimeout(resolve, 1000));
      } catch (error) {
        // Process might already be dead
      }
    }
  } catch (error) {
    // Port is free, continue
  }
}

// Start server
async function startServer() {
  try {
    // Clean up port before starting
    await killProcessOnPort(PORT);
    
    const server = app.listen(PORT, () => {
      console.log(`✅ Server is running on port ${PORT}`);
      console.log(`📍 API endpoint: http://localhost:${PORT}/api`);
      console.log(`🏥 Health check: http://localhost:${PORT}/api/health`);
    });

    // Handle port conflicts
    server.on('error', async (err) => {
      if (err.code === 'EADDRINUSE') {
        console.error(`\n❌ Port ${PORT} is already in use.`);
        console.error(`   Attempting to free the port...`);
        
        await killProcessOnPort(PORT);
        
        // Try one more time after a delay
        await new Promise(resolve => setTimeout(resolve, 2000));
        
        console.error(`   If this persists, run: ./cleanup.sh`);
        console.error(`   Or change PORT in .env file to use a different port.\n`);
        process.exit(1);
      } else {
        console.error('❌ Server error:', err);
        process.exit(1);
      }
    });

    // Graceful shutdown
    const gracefulShutdown = (signal) => {
      console.log(`\n🛑 ${signal} received: closing HTTP server...`);
      server.close(() => {
        console.log('✅ HTTP server closed');
        process.exit(0);
      });
      
      // Force close after 5 seconds
      setTimeout(() => {
        console.error('⚠️  Force closing server...');
        process.exit(1);
      }, 5000);
    };

    process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
    process.on('SIGINT', () => gracefulShutdown('SIGINT'));

  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
}

startServer();
