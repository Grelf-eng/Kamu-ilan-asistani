FROM node:20-bookworm-slim
RUN apt-get update && apt-get install -y python3 make g++ sqlite3 ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY . .
RUN if [ -d "backend" ]; then \
      cd backend && npm install && npm run build; \
    else \
      npm install && npm run build; \
    fi
ENV NODE_ENV=production
ENV PORT=10000
ENV SEED_SAMPLE=true
EXPOSE 10000
CMD ["sh", "-c", "if [ -d 'backend' ]; then cd backend && npm start; else npm start; fi"]
