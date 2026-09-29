# 1. Gamit og official Node.js lightweight image
FROM node:18-alpine

# 2. I-set ang working directory sa sulod sa container
WORKDIR /usr/src/app

# 3. I-copy ang package files ug i-install ang dependencies
COPY package*.json ./
RUN npm install

# 4. I-copy ang tanang files (server.js, public folder, etc.)
COPY . .

# 5. I-open ang port 3000
EXPOSE 3000

# 6. Command para ipadagan ang app
CMD ["npm", "start"]