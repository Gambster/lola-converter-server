# Usa una imagen base de Node.js con Debian Buster
FROM node:18-buster

# Establece el directorio de trabajo en /app
WORKDIR /app

# Instala las dependencias del sistema operativo para convertir imágenes
RUN apt-get update && apt-get install -y \
    dcraw \
    imagemagick \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia los archivos de tu aplicación al contenedor
COPY package*.json ./

# Instala pnpm
RUN npm install -g pnpm

# Instala las dependencias de producción
RUN pnpm install --prod

# Instala las dependencias de desarrollo (para compilar el proyecto TypeScript)
RUN pnpm install --dev

# Copia el resto del código de la aplicación al contenedor
COPY . .

# Ejecuta la compilación de TypeScript
RUN pnpm run build

# Expone el puerto en el que se ejecutará la aplicación
EXPOSE 3000

# Comando para iniciar la aplicación
CMD ["node", "dist/server.js"]
