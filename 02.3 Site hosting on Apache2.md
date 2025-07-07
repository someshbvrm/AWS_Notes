### **Step-by-Step Guide: Host a Website on EC2 Ubuntu with Apache2 (Port 8081) and Redirect IP to Subfolder**  

This guide will help you:  
✅ **Host a website** on an **EC2 Ubuntu** instance using **Apache2**  
✅ **Use a custom port (8081)**  
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

2. **Update System & Install Apache2**  
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install apache2 -y
   ```

---

## **Step 2: Configure Apache2 for Custom Port (8081)**
1. **Enable the Custom Port in Apache**  
   - Edit ports configuration:  
     ```bash
     sudo nano /etc/apache2/ports.conf
     ```
   - Add `Listen 8081` under `Listen 80`:  
     ```
     Listen 80
     Listen 8081
     ```

2. **Create a New VirtualHost for Port 8081**  
   - Create a new config file:  
     ```bash
     sudo nano /etc/apache2/sites-available/website.conf
     ```
   - Paste this configuration (replace `/website` with your folder):  
     ```apache
     <VirtualHost *:8081>
         ServerAdmin admin@example.com
         ServerName your-ec2-ip
         DocumentRoot /var/www/html/website
         ErrorLog ${APACHE_LOG_DIR}/error.log
         CustomLog ${APACHE_LOG_DIR}/access.log combined
     </VirtualHost>
     ```

3. **Enable the Site & Restart Apache**  
   ```bash
   sudo a2ensite website.conf
   sudo systemctl restart apache2
   ```

---

## **Step 3: Redirect IP (Port 80) to Subfolder (Port 8081)**
1. **Modify the Default Apache Config for Port 80**  
   ```bash
   sudo nano /etc/apache2/sites-available/000-default.conf
   ```

2. **Add a Redirect Rule (HTTP → Port 8081)**  
   Replace the existing content with:  
   ```apache
   <VirtualHost *:80>
       ServerAdmin admin@example.com
       ServerName your-ec2-ip
       Redirect permanent / http://your-ec2-ip:8081/
   </VirtualHost>
   ```

3. **Restart Apache**  
   ```bash
   sudo systemctl restart apache2
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
1. **Check Apache Status**  
   ```bash
   sudo systemctl status apache2
   ```

2. **Test in Browser**  
   - Visit:  
     - `http://<EC2_IP>` (Should redirect to `http://<EC2_IP>:8081`)  
     - `http://<EC2_IP>:8081` (Direct access)  

3. **Check Logs if Issues Occur**  
   ```bash
   sudo tail -f /var/log/apache2/error.log
   ```

---

## **Final Notes**
✔ **Security:** Ensure **Security Group** allows **HTTP (80), Custom TCP (8081)**.  
✔ **HTTPS (Optional):** Use **Certbot** (`sudo apt install certbot`) to add SSL.  
✔ **Domain Setup:** Replace `ServerName your-ec2-ip` with your domain if needed.  

---

### **Troubleshooting**
- **"Port 8081 Not Working"** → Check `sudo netstat -tulnp | grep 8081` and verify Apache is listening.  
- **Permission Issues** → Run `sudo chown -R www-data:www-data /var/www/html/website`.  
- **Firewall Issues** → Allow port 8081:  
  ```bash
  sudo ufw allow 8081
  ```
