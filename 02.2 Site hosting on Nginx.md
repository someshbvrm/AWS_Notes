### **Step-by-Step Guide: Host a Website on EC2 Ubuntu with Nginx (Port 8081) and Redirect IP to Subfolder**  

This guide will help you:  
✅ **Host a website** on an **EC2 Ubuntu** instance  
✅ **Use Nginx** on a **custom port (8081)**  
✅ **Redirect IP access** (`http://<EC2_IP>`) to a subfolder (`/var/www/html/website`)  

---

## **Step 1: Launch & Connect to EC2 Ubuntu Instance**
1. **Launch an EC2 Instance**  
   - Go to **AWS EC2 Dashboard** → **Launch Instance**  
   - Choose **Ubuntu Server (LTS)**  
   - Configure **Security Group** (Open ports: **22 (SSH), 80 (HTTP), 8081 (Custom)**  
   - Launch & connect via SSH:  
     ```bash
     ssh -i "your-key.pem" ubuntu@<EC2_Public_IP>
     ```

2. **Update System & Install Nginx**  
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install nginx -y
   ```

---

## **Step 2: Configure Nginx for Custom Port (8081)**
1. **Open Nginx Config File**  
   ```bash
   sudo nano /etc/nginx/sites-available/website
   ```

2. **Paste This Configuration (Replace `/website` with your folder)**  
   ```nginx
   server {
       listen 8081;  # Custom port
       server_name _;  # Responds to any IP

       root /var/www/html/website;  # Your website folder
       index index.html index.htm;

       location / {
           try_files $uri $uri/ =404;
       }
   }
   ```

3. **Enable the Site & Test Nginx**  
   ```bash
   sudo ln -s /etc/nginx/sites-available/website /etc/nginx/sites-enabled/
   sudo nginx -t  # Check for errors
   sudo systemctl restart nginx
   ```

---

## **Step 3: Redirect IP (Port 80) to Subfolder (Port 8081)**
1. **Edit Default Nginx Config**  
   ```bash
   sudo nano /etc/nginx/sites-available/default
   ```

2. **Replace with Redirect Rule (HTTP → Port 8081)**  
   ```nginx
   server {
       listen 80;
       server_name _;

       location / {
           return 301 http://$host:8081;  # Redirect to port 8081
       }
   }
   ```

3. **Restart Nginx**  
   ```bash
   sudo nginx -t
   sudo systemctl restart nginx
   ```

---

## **Step 4: Upload Website Files**
1. **Create Website Folder**  
   ```bash
   sudo mkdir -p /var/www/html/website
   ```

2. **Upload Files (Using `scp` or `git`)**  
   ```bash
   scp -i "your-key.pem" -r /local/website/* ubuntu@<EC2_IP>:/var/www/html/website/
   ```

3. **Set Correct Permissions**  
   ```bash
   sudo chown -R www-data:www-data /var/www/html/website
   sudo chmod -R 755 /var/www/html/website
   ```

---

## **Step 5: Test & Verify**
1. **Check Nginx Status**  
   ```bash
   sudo systemctl status nginx
   ```

2. **Test in Browser**  
   - Visit:  
     - `http://<EC2_IP>` (Should redirect to `http://<EC2_IP>:8081`)  
     - `http://<EC2_IP>:8081` (Direct access)  

3. **Check Logs if Issues Occur**  
   ```bash
   sudo tail -f /var/log/nginx/error.log
   ```

---

## **Final Notes**
✔ **Security:** If using AWS, ensure **Security Group** allows **HTTP (80), Custom TCP (8081)**.  
✔ **HTTPS (Optional):** Use **Certbot** (`sudo apt install certbot`) to add SSL.  
✔ **Domain Setup:** Replace `server_name _;` with your domain if needed.  

---

### **Troubleshooting**
- **"502 Bad Gateway"** → Check if Nginx is running (`sudo systemctl restart nginx`).  
- **Permission Issues** → Run `sudo chown -R www-data:www-data /var/www/html/website`.  
- **Port Not Responding** → Verify AWS Security Group & `sudo ufw allow 8081`.  

