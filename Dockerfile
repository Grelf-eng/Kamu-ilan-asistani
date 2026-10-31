FROM node:20-bookworm-slim
RUN apt-get update && apt-get install -y python3 make g++ sqlite3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
# backend klasörü varsa içindeki HER ŞEYİ (tsconfig, dist, src, public) ana dizine birleştir
RUN if [ -d "backend" ]; then cp -a backend/. . && rm -rf backend; fi
# Bağımlılıkları kur ve derle
RUN npm install
RUN npm run build || true
ENV NODE_ENV=production
ENV PORT=10000
ENV SEED_SAMPLE=true
EXPOSE 10000
CMD ["node", "dist/index.js"]
