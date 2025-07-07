Here’s a **step-by-step guide** to creating a **custom VPC (Virtual Private Cloud)** with **public and private subnets** in **AWS** and **Azure**:

---

# **AWS: Create Custom VPC with Public & Private Subnets**

### **Step 1: Create a VPC**
1. Go to the **AWS Management Console** → **VPC Dashboard**.
2. Click **"Create VPC"**.
   - **Resources to create**: Select **"VPC only"**.
   - **Name tag**: `MyCustomVPC`
   - **IPv4 CIDR block**: `10.0.0.0/16` (or your preferred range).
   - **IPv6 CIDR block**: Leave as **No IPv6** (unless needed).
   - **Tenancy**: Default (Shared).
3. Click **"Create VPC"**.

### **Step 2: Create Subnets**
#### **Public Subnet (for internet-facing resources like web servers)**
1. Click **"Subnets"** → **"Create subnet"**.
   - **VPC ID**: Select `MyCustomVPC`.
   - **Subnet name**: `PublicSubnet-AZ1`.
   - **Availability Zone**: `us-east-1a` (choose your preferred AZ).
   - **IPv4 CIDR block**: `10.0.1.0/24`.
2. Click **"Create subnet"**.
3. Repeat for another AZ (e.g., `PublicSubnet-AZ2` in `us-east-1b` with `10.0.2.0/24`).

#### **Private Subnet (for databases, internal services)**
1. Click **"Create subnet"**.
   - **VPC ID**: `MyCustomVPC`.
   - **Subnet name**: `PrivateSubnet-AZ1`.
   - **Availability Zone**: `us-east-1a`.
   - **IPv4 CIDR block**: `10.0.3.0/24`.
2. Click **"Create subnet"**.
3. Repeat for another AZ (e.g., `PrivateSubnet-AZ2` in `us-east-1b` with `10.0.4.0/24`).

### **Step 3: Create an Internet Gateway (for public subnets)**
1. Go to **"Internet Gateways"** → **"Create internet gateway"**.
   - **Name tag**: `MyIGW`.
2. Click **"Create"**.
3. Select the IGW → **"Actions"** → **"Attach to VPC"** → Choose `MyCustomVPC`.

### **Step 4: Configure Route Tables**
#### **Public Route Table (Routes traffic to the Internet)**
1. Go to **"Route Tables"** → **"Create route table"**.
   - **Name tag**: `PublicRouteTable`.
   - **VPC**: `MyCustomVPC`.
2. Click **"Create"**.
3. Select the route table → **"Routes"** → **"Edit routes"** → **"Add route"**:
   - **Destination**: `0.0.0.0/0`
   - **Target**: `MyIGW` (Internet Gateway).
4. **Subnet associations** → **"Edit subnet associations"** → Select `PublicSubnet-AZ1` & `PublicSubnet-AZ2`.

#### **Private Route Table (No Internet Access by Default)**
1. Create another route table:
   - **Name tag**: `PrivateRouteTable`.
   - **VPC**: `MyCustomVPC`.
2. No need to add an Internet Gateway route (NAT Gateway can be added later if needed).
3. Associate `PrivateSubnet-AZ1` & `PrivateSubnet-AZ2` with this route table.

### **Step 5: Enable Auto-Assign Public IP for Public Subnets**
1. Go to **"Subnets"** → Select `PublicSubnet-AZ1`.
2. **Actions** → **"Edit subnet settings"** → Enable **"Auto-assign public IPv4 address"**.
3. Repeat for `PublicSubnet-AZ2`.

✅ **AWS VPC with Public & Private Subnets is now ready!**

---

# **Azure: Create Virtual Network (VNet) with Public & Private Subnets**

### **Step 1: Create a Virtual Network (VNet)**
1. Go to **Azure Portal** → **"Virtual networks"** → **"+ Create"**.
2. Configure:
   - **Subscription**: Select your subscription.
   - **Resource group**: Create new (e.g., `MyVNet-RG`).
   - **Name**: `MyCustomVNet`.
   - **Region**: `East US` (or preferred).
3. **IPv4 Address Space**: `10.0.0.0/16`.
4. Click **"Next: Subnets"**.

### **Step 2: Create Subnets**
#### **Public Subnet (for web servers, load balancers)**
1. **Subnet name**: `PublicSubnet`.
2. **Subnet address range**: `10.0.1.0/24`.
3. **NAT Gateway**: None (unless needed).
4. **Network Security Group (NSG)**: Create new (`PublicSubnet-NSG`).
5. **Route table**: Default (or create a custom one later).

#### **Private Subnet (for databases, internal services)**
1. Click **"+ Add subnet"**.
   - **Name**: `PrivateSubnet`.
   - **Address range**: `10.0.2.0/24`.
   - **NSG**: Create new (`PrivateSubnet-NSG`).
   - **Route table**: Default (or create a custom one later).
2. Click **"Review + create"** → **"Create"**.

### **Step 3: Configure Public Access (if needed)**
- Public subnets can host **public load balancers, VMs with public IPs**.
- Private subnets **do not allow direct internet access** (use **NAT Gateway** or **Azure Firewall** if needed).

✅ **Azure VNet with Public & Private Subnets is now ready!**

---

### **Comparison Table**
| **Step**              | **AWS**                          | **Azure**                        |
|-----------------------|----------------------------------|----------------------------------|
| **Networking Unit**   | VPC                              | Virtual Network (VNet)           |
| **Subnet Scope**      | Always AZ-bound                  | Regional (but can be zonal)      |
| **Internet Access**   | Internet Gateway (IGW)           | NAT Gateway / Public IPs         |
| **Route Tables**      | Separate for public/private      | Optional UDR (User-Defined Routes) |
| **Security**          | Security Groups & NACLs          | Network Security Groups (NSGs)   |

Would you like additional details on **NAT Gateways, Bastion Hosts, or Peering?** 😊