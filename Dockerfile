FROM node:20-bookworm-slim
RUN apt-get update && apt-get install -y python3 make g++ sqlite3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN if [ -d "backend" ] && [ -f "backend/package.json" ]; then \
      cp -rn backend/* . || true; \
    fi
RUN npm install
RUN npm run build || (if [ -d "backend" ]; then cd backend && npm run build; fi) || true
ENV NODE_ENV=production
ENV PORT=10000
ENV SEED_SAMPLE=true
EXPOSE 10000
CMD ["sh", "-c", "if [ -d 'backend/dist' ]; then cd backend && npm start; elif [ -f 'dist/index.js' ]; then node dist/index.js; else npm start; fi"]
