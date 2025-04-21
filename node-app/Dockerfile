# Imagen base de Node
FROM node:24

# Crear directorio de trabajo
WORKDIR /app

# Copiar archivos
COPY package*.json ./
RUN npm install

COPY . .

# Exponer puerto
EXPOSE 3000

# Comando para iniciar
CMD ["node", "index.js"]
