# **Accessing EC2 Instances Using AWS Systems Manager (SSM)**

AWS Systems Manager (SSM) provides secure remote access to EC2 instances **without needing SSH keys, bastion hosts, or open inbound ports**. Here's a complete step-by-step guide:

---

## **Prerequisites**
✅ **EC2 Instance Requirements:**
- **Amazon Linux 2, Ubuntu, or Windows** (with SSM Agent pre-installed on most modern AMIs)
- **IAM Instance Profile** with `AmazonSSMManagedInstanceCore` policy attached
- **Internet access** (or VPC endpoints for private networks)

✅ **Your AWS Account Needs:**
- IAM permissions for `ssm:StartSession`

---

## **Step-by-Step Guide**

### **1. Configure IAM Role for EC2 Instance**
1. Go to **IAM Console** → **Roles** → **Create Role**
2. Select **AWS service** → **EC2** → **Next**
3. Attach policy: **AmazonSSMManagedInstanceCore**
4. Name the role (e.g., `EC2-SSM-Role`) → **Create Role**

### **2. Attach IAM Role to EC2 Instance**
1. Go to **EC2 Console**
2. Select your instance → **Actions** → **Security** → **Modify IAM Role**
3. Select the `EC2-SSM-Role` → **Update IAM Role**

### **3. Verify SSM Agent is Running**
```bash
# For Linux instances:
sudo systemctl status snap.amazon-ssm-agent.amazon-ssm-agent

# If not running, install it:
sudo snap install amazon-ssm-agent --classic
sudo systemctl start amazon-ssm-agent
```

> **Note:** Most Amazon Linux 2 and Ubuntu AMIs have SSM Agent pre-installed.

---

## **4. Access Instance Using Session Manager**

### **Method 1: AWS Management Console**
1. Go to **AWS Systems Manager** → **Session Manager**
2. Click **Start Session**
3. Select your EC2 instance → **Start Session**
4. You'll get a browser-based terminal:

![AWS Session Manager Terminal](https://d1.awsstatic.com/products/Systems%20Manager/product-page-diagram_Systems-Manager_Session-Manager.4f4bc9d7a5b0b4b4d8f1e3e3f1e3e3f1.png)

### **Method 2: AWS CLI**
1. Install AWS CLI:
   ```bash
   aws --version  # Ensure CLI is installed
   ```
2. Start a session:
   ```bash
   aws ssm start-session --target YOUR_INSTANCE_ID
   ```
3. Exit with `exit` or `Ctrl+D`

---

## **5. (Optional) Enable SSH Over SSM (Port Forwarding)**
If you need SSH access **without opening port 22**:
```bash
aws ssm start-session \
    --target YOUR_INSTANCE_ID \
    --document-name AWS-StartSSHSession \
    --parameters 'portNumber=22'
```
Then connect via SSH:
```bash
ssh -i your-key.pem ec2-user@localhost -p 2222
```

---

## **6. Troubleshooting**
| **Issue** | **Solution** |
|-----------|-------------|
| Instance not appearing in Session Manager | Check IAM role & SSM Agent status |
| "TargetNotConnected" error | Verify instance has internet access |
| Permission denied | Ensure `AmazonSSMManagedInstanceCore` policy is attached |

---

## **Security Best Practices**
🔒 **No open inbound ports** (more secure than SSH)  
🔒 **Log all sessions** in CloudTrail/S3  
🔒 **Use IAM policies** to restrict access  

---

## **Advanced Use Cases**
- **Run commands remotely** without logging in:
  ```bash
  aws ssm send-command --instance-ids YOUR_INSTANCE_ID \
      --document-name "AWS-RunShellScript" \
      --parameters 'commands=["df -h"]'
  ```
- **Automate patch management** using SSM Run Command
- **Secure database access** via SSH tunneling over SSM

---

### **Conclusion**
AWS Systems Manager provides **secure, auditable, and keyless access** to EC2 instances. This eliminates the need for:  
❌ SSH keys  
❌ Bastion hosts  
❌ Open inbound ports  

🚀 **Next Steps:**  
- Set up **SSM Session logging** to S3  
- Explore **SSM Run Command** for bulk operations  

Let me know if you need help customizing this setup! 🛠️