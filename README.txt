check post command to get Mcp-Session-Id: dtx6pCcQLFrIXGUhuXiaTQ:
emmalanda@PROXYMITYLAP319 sql % curl -i \
  -X POST http://internal-alb-sql-mcp-server-20360269.eu-west-1.elb.amazonaws.com:80/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-06-18",
      "capabilities": {},
      "clientInfo": {
        "name": "curl",
        "version": "1.0"
      }
    }
  }'

  Documentation: https://learn.microsoft.com/en-us/azure/data-api-builder/mcp/quickstart-visual-studio-code?tabs=stdio
