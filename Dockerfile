# Stage 1: Build the Node.js app
FROM node:18.20.0 as node-build

WORKDIR /app

# Copy package files
COPY package.*json ./

# Install dependencies
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build

# Stage 2: Serve the app using NGINX
FROM nginx:latest

# Remove default NGINX website
RUN rm -rf /usr/share/nginx/html/*

# Copy the built app from the previous stage
COPY --from=node-build /app/build /usr/share/nginx/html

# Expose port 80 for NGINX
EXPOSE 80

# Run NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
