FROM node:20-bookworm-slim

# SQLite native derleme ve SSL bağımlılıkları
RUN apt-get update && apt-get install -y python3 make g++ sqlite3 ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Backend bağımlılıklarını kur
COPY backend/package*.json ./backend/
WORKDIR /app/backend
RUN npm install

# Kaynak kodları kopyala ve derle
COPY backend/ ./
RUN npm run build

ENV NODE_ENV=production
ENV PORT=4000
ENV SEED_SAMPLE=true

EXPOSE 4000

CMD ["node", "dist/index.js"]
