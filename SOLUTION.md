# ce-lab-deploy-nodejs

Production-ready Node.js Express deployment on Amazon Linux 2023 using:

* Node.js 18
* Express.js
* PM2
* Nginx reverse proxy
* AWS EC2

---

# Deployment Lab Overview

This lab demonstrates deploying a production-ready Node.js application on an EC2 instance.

The deployment includes:

* Installing Node.js
* Creating a Node.js Express application
* Managing the app with PM2
* Configuring Nginx as a reverse proxy
* Adding a health check endpoint
* Ensuring the app survives reboot

---

# EC2 Connection

SSH into the EC2 instance:

```bash
ssh -i my-third-key.pem ec2-user@18.195.6.216
```

---

# Step 1 — Install Node.js

```bash
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs
```

Verify installation:

```bash
node -v
npm -v
```

Installed version from deployment:

```bash
nodejs-18.20.8
```

---

# Step 2 — Create Application Directory

```bash
mkdir ~/app && cd ~/app
```

Initialize Node.js project:

```bash
npm init -y
```

Install Express:

```bash
npm install express
```

---

# Step 3 — Create app.js

Create the file:

```bash
nano app.js
```

Paste the following code:

```javascript
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.json({
    message: 'Week 2 Deployment Lab',
    hostname: process.env.HOSTNAME,
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date()
  });
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

---

# Important Lesson Learned

Initially, the JavaScript code was pasted directly into the Linux terminal instead of inside a file.

This caused multiple bash syntax errors such as:

```bash
-bash: syntax error near unexpected token '('
-bash: const: command not found
```

The issue was fixed by creating the file properly using:

```bash
nano app.js
```

Then pasting the application code inside the editor.

---

# Step 4 — Install PM2

Install PM2 globally:

```bash
sudo npm install -g pm2
```

Start the application:

```bash
pm2 start app.js --name myapp
```

Example successful output:

```bash
│ 0  │ myapp │ fork │ 0 │ online │
```

Enable startup after reboot:

```bash
pm2 startup
```

Save PM2 process list:

```bash
pm2 save
```

---

# Step 5 — Install Nginx

Install Nginx:

```bash
sudo yum install -y nginx
```

---

# Step 6 — Configure Reverse Proxy

Create Nginx configuration:

```bash
sudo tee /etc/nginx/conf.d/app.conf <<EOF
server {
    listen 80;
    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
    }
}
EOF
```

---

# Step 7 — Start and Enable Nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

---

# Health Check Endpoint

Application health endpoint:

```bash
http://YOUR_PUBLIC_IP/health
```

Example response:

```json
{
  "status": "healthy",
  "timestamp": "2026-05-01T07:30:00.000Z"
}
```

---

# Application Verification

Test locally on the EC2 instance:

```bash
curl http://localhost
```

Test health endpoint:

```bash
curl http://localhost/health
```

---

# Deployment Success Criteria

✅ Node.js installed
✅ Express application running
✅ PM2 process manager configured
✅ Nginx reverse proxy configured
✅ Health endpoint working
✅ Application survives reboot
✅ Application accessible from internet

---

# Repository Structure

```text
ce-lab-deploy-nodejs/
├── app.js
├── package.json
├── ecosystem.config.js
├── nginx/
│   └── app.conf
├── scripts/
│   └── deploy.sh
├── screenshots/
└── README.md
└── SOLUTION.md
```

---

Example commands:

```bash
pm2 status
sudo systemctl status nginx
curl http://localhost/health
```

---

# Author

Eric Borba
