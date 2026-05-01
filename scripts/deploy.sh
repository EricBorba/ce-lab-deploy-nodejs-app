#!/bin/bash

set -e

echo "Installing Node.js..."
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

echo "Creating application directory..."
mkdir -p ~/app
cd ~/app

echo "Initializing Node.js project..."
npm init -y

echo "Installing Express..."
npm install express

echo "Installing PM2..."
sudo npm install -g pm2

echo "Starting application..."
pm2 start app.js --name myapp

echo "Saving PM2 configuration..."
pm2 save

echo "Installing Nginx..."
sudo yum install -y nginx

echo "Creating Nginx configuration..."
sudo tee /etc/nginx/conf.d/app.conf <<EOF
server {
listen 80;

```
location / {
    proxy_pass http://localhost:8080;
    proxy_http_version 1.1;
    proxy_set_header Host \$host;
}
```

}
EOF

echo "Starting Nginx..."
sudo systemctl start nginx
sudo systemctl enable nginx

echo "Deployment completed successfully."
