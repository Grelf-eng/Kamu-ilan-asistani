FROM node:20-bookworm-slim
RUN apt-get update && apt-get install -y python3 make g++ sqlite3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
# TypeScript'i doğrudan sisteme kur (127 komut bulunamadı hatasını kesin çözer)
RUN npm install -g typescript tsx
COPY . .
# backend klasörü varsa içindekileri kök dizine çek
RUN if [ -d "backend" ]; then \
      cp -rn backend/* . || true; \
    fi
# Bağımlılıkları kur ve derle
RUN npm install --include=dev
RUN tsc -p tsconfig.json || true
ENV NODE_ENV=production
ENV PORT=10000
ENV SEED_SAMPLE=true
EXPOSE 10000
CMD ["sh", "-c", "if [ -f 'dist/index.js' ]; then node dist/index.js; elif [ -f 'backend/dist/index.js' ]; then node backend/dist/index.js; else npm start; fi"]
