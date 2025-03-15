# Frontend React Application Dockerfile
FROM node:18-alpine as build

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Copy source files
COPY . .

# Build the application
RUN npm run build

# Production environment
FROM nginx:alpine

# Copy built files to Nginx serve directory
COPY --from=build /app/build /usr/share/nginx/html

# Copy Nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]