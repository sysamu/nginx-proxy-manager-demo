#!/bin/bash

set -e

echo "🕸️ Verificando red Docker 'npm-network'..."

if ! docker network ls | grep -q "npm-network"; then
  echo "🔧 Creando red externa 'npm-network'..."
  docker network create npm-network
else
  echo "✅ Red 'npm-network' ya existe"
fi

echo "🚀 Levantando NGINX Proxy Manager..."
cd ./nginx-proxy-manager
docker-compose up -d

echo "⏳ Esperando a que NGINX Proxy Manager esté listo..."
until curl -s http://localhost:81 > /dev/null; do
  echo -n "."
  sleep 2
done

echo ""
echo "✅ NGINX Proxy Manager está activo"

echo "🟢 Levantando app Node..."
cd ../node-app
docker-compose up -d

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
echo "🛡️ Recordá configurar tus certificados con mkcert o Let's Encrypt si apuntás dominios reales."
echo "------------------------------------------------"