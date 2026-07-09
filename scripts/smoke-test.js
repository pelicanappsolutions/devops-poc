const http = require('http');

const baseUrl = process.env.SMOKE_URL || 'http://localhost:3000';

function request(path) {
  return new Promise((resolve, reject) => {
    http.get(`${baseUrl}${path}`, (res) => {
      let data = '';
      res.on('data', chunk => data += chunk);
      res.on('end', () => resolve({ statusCode: res.statusCode, body: data }));
    }).on('error', reject);
  });
}

async function main() {
  const checks = [
    { path: '/', expected: 200 },
    { path: '/healthz', expected: 200 },
    { path: '/readyz', expected: 200 },
    { path: '/version', expected: 200 }
  ];

  for (const check of checks) {
    const result = await request(check.path);
    if (result.statusCode !== check.expected) {
      console.error(`FAILED ${check.path}: expected ${check.expected}, got ${result.statusCode}`);
      process.exit(1);
    }
    console.log(`PASS ${check.path}: ${result.statusCode}`);
  }

  console.log('All smoke tests passed.');
}

main().catch(error => {
  console.error('Smoke test failed:', error.message);
  process.exit(1);
});
