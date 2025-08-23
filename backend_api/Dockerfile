FROM node:18

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY firebase/ ./firebase/
COPY assets/ ./assets/
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
