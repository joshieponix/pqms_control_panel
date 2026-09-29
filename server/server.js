const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const path = require('path');
const os = require('os'); // <--- BAG-O: Kinahanglan i-import ang 'os' module!
const fs = require('fs');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
const { query, validationResult } = require('express-validator');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*", // Gi-allow ang React/Browser clients
    methods: ["GET", "POST"]
  }
});


// NEW ADD SECURITY
// Set up ug static API Key (Sa production, maayo ibutang kini sa .env file)
const API_KEY = process.env.API_KEY || 'PQMS_API_KEY_2O26';

// ---------------------------------------------------------
// 1. CORS SECURITY SETUP
// ---------------------------------------------------------
// Dili mag-allow ug '*' (tanan). Pilia lang ang authorized local network o IP.
const allowedOrigins = [
  'http://localhost:3000',
  'http://127.0.0.1:3000',
  // Pwede nimong idugang ang tiwas nga IP sa client o subnet
];
const corsOptions = {
  origin: function (origin, callback) {
    // I-allow ang requests nga walay origin (pareho sa mobile apps, Electron, o Flutter desktop)
    if (!origin || allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error('CORS Policy Error: Blocked by Access Control'));
    }
  },
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type', 'x-api-key'],
};

app.use(cors(corsOptions));
app.use(express.json());

// ---------------------------------------------------------
// 2. RATE LIMITING SETUP
// ---------------------------------------------------------
// Mag-limit sa sobra-sobra nga requests aron malikayan ang DoS attacks
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 100, // Maximum nga 100 requests matag 15 mins per IP
  message: { error: 'Daghan kaayong requests gikan sa imong IP, try usab unya.' },
  standardHeaders: true,
  legacyHeaders: false,
});

// I-apply ang rate limiter sa tanang `/api/` endpoints
app.use('/api/', apiLimiter);

// ---------------------------------------------------------
// 3. API KEY AUTHENTICATION MIDDLEWARE
// ---------------------------------------------------------
function authenticateApiKey(req, res, next) {
  const clientApiKey = req.headers['x-api-key'];

  if (!clientApiKey || clientApiKey !== API_KEY) {
    return res.status(401).json({ error: 'Unauthorized: Invalido o walay API Key.' });
  }

  next(); // Endorsed padulong sa sunod nga route
}
// END SECURITY

// Serve static HTML files gikan sa 'public' folder
// app.use(express.static(path.join(process.cwd(), 'public'))); // THIS IS TEMPORARY COMMENT
const publicPath = path.join(process.cwd(), 'public');
app.use(express.static(publicPath));

function getLocalIpAddress() {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const net of interfaces[name]) {
      // I-filter ang IPv4 ug dili loopback (127.0.0.1)
      if (net.family === 'IPv4' && !net.internal) {
        return net.address;
      }
    }
  }
  return '127.0.0.1'; // Fallback kung walay network connection
}

// Temporary in-memory database para sa print queue
let printQueue = [];
let idCounter = 1;

// Socket.IO Logic
io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);

  // Pag-connect sa client, ipadala dayon ang kasamtangang print queue
  socket.emit('initial_queue', printQueue);

  // 1. Pag-receive og bag-ong print job gikan sa Operator
  socket.on('add_job', (jobData) => {
    const newJob = {
      id: idCounter++,
      filename: jobData.filename,
      copies: jobData.copies,
      status: 'Pending',
      createdAt: new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    };

    printQueue.push(newJob);
    io.emit('job_added', newJob);
  });

  // 2. Pag-update sa status sa job gikan sa Production
  socket.on('update_job_status', (data) => {
    const job = printQueue.find(j => j.id === data.id);
    if (job) {
      job.status = data.status;
      io.emit('job_status_updated', { id: job.id, status: job.status });
    }
  });

  // 3. Pag-delete o pag-clear sa completed job
  socket.on('remove_job', (jobId) => {
    printQueue = printQueue.filter(j => j.id !== jobId);
    io.emit('job_removed', jobId);
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});




// ADD THIS ROUTE: Para dali ra ug segurado nga ma-detect sa Flutter UI
app.get('/api/status', (req, res) => {
  res.status(200).json({ status: 'running' });
});

// API ENDPOINT FOR DETECT FILES
app.get('/api/info',
authenticateApiKey // Require API Key
,[
  // Sample Input Sanitization & Validation gamit ang express-validator
    query('filter').optional().trim().escape().isAlphanumeric(),
], (req, res)=>{
    const localIp = getLocalIpAddress();

    fs.readdir(publicPath, (err, files)=>{
        if (err){
          return res.status(500).json({ error: 'Failed to scan files' })
        }

        // Filter lang ang .html files
        const htmlFiles = files.filter(file => file.endsWith('.html'));

        // I-build ang kompletong URLs (e.g. http://172.0.1.2/operator.html)
        const fileUrls = htmlFiles.map(file => `http://${localIp}:${PORT}/${file}`);

        res.json({
            ip: localIp,
            port: PORT,
            detectedFiles: htmlFiles,
            urls: fileUrls // Dinhi naay list sa tanang URL nga pwede nimo i-display
          });
    })
})

const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0'; // Essential para ma-access via IP




// BAG-O: Gi-pasa ang HOST parameter sa listen()
server.listen(PORT, HOST, () => {
  const localIp = getLocalIpAddress();
  console.log(`Server is running on: http://${localIp}:${PORT}/`);
  console.log(`Print Queue Server active on port ${PORT}.`);
});