# Use official nginx image
FROM nginx:alpine

# Set maintainer label
LABEL maintainer="M-Ehtasham"

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy static files to nginx html directory
COPY . /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
