const { exec } = require('child_process');
const axios = require('axios');

let server;

beforeAll(done => {
  server = exec('node src/app.js', () => {});
  setTimeout(done, 1000); // give the server time to start
});

afterAll(() => {
  if (server) server.kill();
});

test('GET /health returns healthy', async () => {
  const res = await axios.get('http://localhost:8080/health');
  expect(res.status).toBe(200);
  expect(res.data).toEqual({ status: 'healthy' });
});
