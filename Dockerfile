# Stage 1: Build the Angular app
FROM node:23-alpine3.20 as build

# Set the working directory
WORKDIR /app

# Copy the package.json and package-lock.json
COPY ./package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY ./ .

# Build the Angular app
RUN npm run build --configuration=production

# Stage 2: Serve the Angular app using Nginx
FROM nginx:alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Remove the default static files
RUN rm -rf ./*

# Copy the built Angular app from the previous stage
COPY --from=build /app/dist/client/browser ./

# Remove the default Nginx config
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy your custom Nginx configuration
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 8080
EXPOSE 8080

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]