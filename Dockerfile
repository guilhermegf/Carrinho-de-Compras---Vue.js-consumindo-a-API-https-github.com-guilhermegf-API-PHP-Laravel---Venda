# Use a imagem oficial do node como base
FROM node:latest

# Define o diretório de trabalho para o aplicativo
WORKDIR /app

# Copie o arquivo package.json e package-lock.json para o diretório de trabalho
COPY package*.json ./

# Instale as dependências do aplicativo
RUN npm install

# Copie o restante dos arquivos do aplicativo para o diretório de trabalho
COPY . .

# Compile o aplicativo
RUN npm run build

# Expõe a porta 8080 do contêiner
EXPOSE 8080

# Inicia o servidor web do aplicativo
CMD [ "npm", "run", "serve" ]
