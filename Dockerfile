# Stage 1: Build the Node.js app using Vite
FROM node:18.20.0 as node-build

WORKDIR /app

# Copy package files and install dependencies
COPY package.*json ./
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build  # This will generate the output in the 'dist/' directory

# Stage 2: Serve the app using NGINX
FROM nginx:latest

# Remove the default NGINX website content
RUN rm -rf /usr/share/nginx/html/*

# Copy the built Node.js app (from the previous stage) into NGINX's HTML directory
# 'dist' is the default directory where Vite places the production build
COPY --from=node-build /app/dist /usr/share/nginx/html  # Ensure the 'dist/' folder exists

# Expose port 80 for NGINX
EXPOSE 80

# Run NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
