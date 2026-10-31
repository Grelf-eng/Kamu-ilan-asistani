FROM node:20-bookworm-slim
RUN apt-get update && apt-get install -y python3 make g++ sqlite3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
# backend klasörü varsa içine girip derle, yoksa ana dizinde derle
RUN if [ -d "backend" ]; then \
      cd backend && npm install && npm run build; \
    else \
      npm install && npm run build; \
    fi
# Dosyaları ana dizine de kopyala (Render'ın aradığı tam yerde hazır olsun)
RUN if [ -d "backend/dist" ]; then \
      cp -r backend/dist . && \
      cp -r backend/public . && \
      cp -r backend/data . && \
      cp -r backend/node_modules . && \
      cp backend/package*.json . || true; \
    fi
ENV NODE_ENV=production
ENV PORT=10000
ENV SEED_SAMPLE=true
EXPOSE 10000
CMD ["node", "dist/index.js"]
