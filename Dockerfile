# Stage 1: Build the Node.js app
FROM node:18.20.0 as node-build

WORKDIR /app

# Copy package files and install dependencies
COPY package.*json ./
RUN npm install

# Copy the rest of the app and build it
COPY . .
RUN npm run build  # Make sure this generates the build in the 'build/' folder

# Stage 2: Serve the app using NGINX
FROM nginx:latest

# Remove the default NGINX website content
RUN rm -rf /usr/share/nginx/html/*

# Copy the built Node.js app (from the previous stage) into NGINX's HTML directory
# Make sure the output folder from 'npm run build' is 'build/'
COPY --from=node-build /app/build /usr/share/nginx/html

# Expose port 80 for NGINX
EXPOSE 80

# Run NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
