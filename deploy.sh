#!/bin/bash

set -e

REBUILD_NODE=false
ONLY_NGINX=false

# Parse flags
for arg in "$@"; do
  case $arg in
    --rebuild-node)
      REBUILD_NODE=true
      ;;
    --only-nginx)
      ONLY_NGINX=true
      ;;
  esac
done

echo "🕸️ Verificando red Docker 'npm-network'..."
if ! docker network ls | grep -q "npm-network"; then
  echo "🔧 Creando red externa 'npm-network'..."
  docker network create npm-network
else
  echo "✅ Red 'npm-network' ya existe"
fi

echo "🚀 Levantando NGINX Proxy Manager..."
cd ./nginx-proxy-manager
docker compose up -d

echo "⏳ Esperando a que NGINX Proxy Manager esté listo..."
until curl -s http://localhost:81 > /dev/null; do
  echo -n "."
  sleep 2
done

echo ""
echo "✅ NGINX Proxy Manager está activo en http://<IP>:81"

if [ "$ONLY_NGINX" = true ]; then
  echo "🛑 Flag --only-nginx activo. Finalizando el deploy aquí."
  exit 0
fi

# Si no está limitado a NGINX, seguimos con Node
cd ../node-app

if [ "$REBUILD_NODE" = true ]; then
  echo "♻️ Rebuild forzado del contenedor Node..."
  docker compose build
fi

echo "🟢 Levantando app Node..."
docker compose up -d

echo ""
echo "🌍 Todo desplegado correctamente."
echo "------------------------------------------------"
echo "🔧 Accedé al panel de NGINX Proxy Manager:"
echo "👉 http://<IP_DE_TU_VM>:81"
echo ""
echo "🔐 Primer login por defecto:"
echo "   Usuario: admin@example.com"
echo "   Contraseña: changeme"
echo "------------------------------------------------"
