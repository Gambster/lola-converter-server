# Usa una imagen oficial de Node.js (elige la versión que necesites, por ejemplo, v18)
FROM node:18-alpine

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instala las dependencias del sistema necesarias para la conversión de imágenes
RUN apt-get update && apt-get install -y \
  dcraw \
  ufraw \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

# Copia los archivos de configuración de tu proyecto
COPY package.json pnpm-lock.yaml ./

# Instala pnpm globalmente
RUN npm install -g pnpm

# Instala las dependencias del proyecto usando pnpm
RUN pnpm install 

# Copia el resto del código de la aplicación
COPY . .

# Construye la aplicación
RUN pnpm build

# Expón el puerto que usa tu aplicación
EXPOSE 3000

# Define el comando para ejecutar la aplicación
CMD ["pnpm", "start"]
