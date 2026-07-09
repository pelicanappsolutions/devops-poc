const http = require('http');

const port = process.env.PORT || 3000;
const version = process.env.APP_VERSION || 'local';
const environment = process.env.APP_ENV || 'dev';
const startTime = new Date();

function json(res, statusCode, body) {
  res.statusCode = statusCode;
  res.setHeader('Content-Type', 'application/json');
  res.end(JSON.stringify(body, null, 2));
}

function text(res, statusCode, body) {
  res.statusCode = statusCode;
  res.setHeader('Content-Type', 'text/plain');
  res.end(body);
}

const server = http.createServer((req, res) => {
  const path = req.url.split('?')[0];

  if (path === '/') {
    return text(
      res,
      200,
      `Hello from the DevOps POC app.\nEnvironment: ${environment}\nVersion: ${version}\n`
    );
  }

  if (path === '/healthz') {
    return json(res, 200, {
      status: 'ok',
      service: 'devops-poc-app',
      uptimeSeconds: Math.floor(process.uptime()),
      startedAt: startTime.toISOString()
    });
  }

  if (path === '/readyz') {
    return json(res, 200, {
      ready: true,
      dependencies: {
        database: 'not-required-for-lab',
        cache: 'not-required-for-lab'
      }
    });
  }

  if (path === '/version') {
    return json(res, 200, {
      version,
      environment,
      nodeVersion: process.version
    });
  }

  if (path === '/slow') {
    setTimeout(() => {
      return json(res, 200, {
        message: 'Simulated slow response complete',
        delayMs: 1500
      });
    }, 1500);
    return;
  }

  if (path === '/error') {
    console.error(`[${new Date().toISOString()}] Simulated application error`);
    return json(res, 500, {
      error: 'Simulated error for troubleshooting practice'
    });
  }

  return json(res, 404, {
    error: 'Not found',
    path
  });
});

server.listen(port, () => {
  console.log(`[${new Date().toISOString()}] Server running on port ${port}`);
  console.log(`[${new Date().toISOString()}] Environment=${environment} Version=${version}`);
});
