# Usa una imagen base de Node.js con Debian Buster, que incluye apt-get
FROM node:18-buster

# Establece el directorio de trabajo en /app
WORKDIR /app

# Instala las dependencias del sistema necesarias para la conversión de imágenes
RUN apt-get update && apt-get install -y \
  dcraw \
  ufraw \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

# Copia los archivos de tu aplicación al contenedor
COPY package*.json ./

# Instala las dependencias de Node.js
RUN npm install --production

# Copia el resto del código de la aplicación
COPY . .

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "dist/server.js"]
