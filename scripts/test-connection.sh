#!/bin/bash
# Test Jupyter MCP Server connection

set -e

# Check if uv is installed
if ! command -v uvx &> /dev/null; then
    echo "❌ uvx not found. Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi

# Check required env vars
if [ -z "$JUPYTER_URL" ]; then
    echo "❌ JUPYTER_URL not set"
    echo "Usage: JUPYTER_URL=http://localhost:8888 JUPYTER_TOKEN=your_token $0"
    exit 1
fi

if [ -z "$JUPYTER_TOKEN" ]; then
    echo "❌ JUPYTER_TOKEN not set"
    echo "Usage: JUPYTER_URL=http://localhost:8888 JUPYTER_TOKEN=your_token $0"
    exit 1
fi

echo "🔍 Testing Jupyter API connection..."
response=$(curl -s -w "\n%{http_code}" -H "Authorization: token $JUPYTER_TOKEN" "$JUPYTER_URL/api")
http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | head -n -1)

if [ "$http_code" -eq 200 ]; then
    echo "✅ Jupyter API responding (HTTP $http_code)"
    echo "Response: $body"
else
    echo "❌ Jupyter API failed (HTTP $http_code)"
    echo "Response: $body"
    exit 1
fi

echo ""
echo "🚀 Testing jupyter-mcp-server..."
echo "Run this in your MCP client config:"
echo ""
echo '{'
echo '  "mcpServers": {'
echo '    "jupyter": {'
echo '      "command": "uvx",'
echo '      "args": ["jupyter-mcp-server@latest"],'
echo '      "env": {'
echo "        \"JUPYTER_URL\": \"$JUPYTER_URL\","
echo "        \"JUPYTER_TOKEN\": \"$JUPYTER_TOKEN\","
echo '        "ALLOW_IMG_OUTPUT": "true"'
echo '      }'
echo '    }'
echo '  }'
echo '}'
