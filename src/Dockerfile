FROM node:14
LABEL org.opencontainers.image.source https://github.com/octodemo/GitHub-Platform-Demo
WORKDIR /usr/src/app
COPY . .
RUN npm install
COPY . .
CMD ["index.js"]
