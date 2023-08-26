// Config
const RCON_URL = 'https://rpmod.jediholo.net/ws/ServerService/jsonrpc/v/051';
const RCON_PASSWORD = process.env.RCON_PASSWORD || '';
const RCON_SERVERS = JSON.parse(process.env.RCON_SERVERS || '{}');

// Rcon command execution
module.exports.exec = async (serverName, command) => {
  // Get server
  const server = RCON_SERVERS[serverName];
  if (server === undefined)
    throw new Error(`Unknown server '${serverName}'`);

  // Build request
  const serverHostPort = server.split(':', 2);
  const requestBody = {
    'jsonrpc': '2.0',
    'id': 'jka-logs-processor',
    'method': 'Rcon',
    'params': {
      'host': serverHostPort[0],
      'port': serverHostPort[1],
      'password': RCON_PASSWORD,
      'command': command
    }
  };
  const request = {
    method: 'POST',
    headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    body: JSON.stringify(requestBody)
  };

  // Call service
  const response = await fetch(RCON_URL, request);
  if (!response.ok)
    throw new Error(`HTTP error code ${response.status}: ${response.statusText}`);

  // Parse response
  const responseBody = await response.json();
  if (responseBody.jsonrpc != '2.0') {
    throw new Error('Invalid response format (not JSON-RPC 2.0)');
  } else if (responseBody.result !== undefined) {
    return responseBody.result;
  } else if (responseBody.error !== undefined) {
    throw new Error(responseBody.error.message);
  } else {
    throw new Error('Invalid response format (no result or error field)');
  }
};
