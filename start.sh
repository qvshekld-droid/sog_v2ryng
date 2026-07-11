#!/bin/bash
set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Starting SOG Panel + nginx reverse proxy...${NC}"

export NGINX_PORT=3000

cd /usr/local/x-ui

echo -e "${YELLOW}🔧 Applying panel settings...${NC}"
./x-ui setting -port 2053 -webBasePath /managepanel/ -username admin -password admin || true

echo -e "${CYAN}🔧 Building nginx.conf for fixed port: $NGINX_PORT${NC}"
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo -e "${GREEN}▶️ Starting panel in background...${NC}"
./x-ui &
X_UI_PID=$!

sleep 2

echo -e "${GREEN}▶️ Starting nginx in foreground on port $NGINX_PORT...${NC}"
nginx -t
exec nginx -g "daemon off;"
