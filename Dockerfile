FROM ubuntu:latest

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy the website files into the Nginx directory
COPY . /var/www/html/

# Expose port 80 for the website
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

