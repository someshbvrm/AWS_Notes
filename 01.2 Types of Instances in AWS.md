Here's a comprehensive yet concise breakdown of **AWS EC2 Instance Purchase Options**, including definitions, key characteristics, and practical notes:

---

### **1. On-Demand Instances**  
**Definition**: Pay-as-you-go instances billed by the second/hour with no long-term commitment.  
**Key Notes**:  
- **Pricing**: Highest cost (no discounts)  
- **Availability**: Always provisioned when capacity exists  
- **Use Cases**:  
  - Short-term, unpredictable workloads  
  - Development/testing environments  
  - Applications with sudden traffic spikes  
**Example**: `m5.large` for a temporary dev server.  

---

### **2. Spot Instances**  
**Definition**: Bid for unused EC2 capacity at massive discounts (up to 90% off On-Demand).  
**Key Notes**:  
- **Pricing**: Cheapest option but can be terminated with 2-minute warning  
- **Availability**: Depends on unused capacity in AWS's pool  
- **Best Practices**:  
  - Use for fault-tolerant workloads (e.g., batch processing)  
  - Combine with **Spot Fleets** to mix instance types/AZs  
  - Set max price ≤ On-Demand rate  
**Example**: `r5.2xlarge` for cost-effective big data processing.  

---

### **3. Reserved Instances (RIs)**  
**Definition**: Pre-purchase instances for 1/3 years at discounted rates.  
**Types**:  
- **Standard RIs**: Highest discount, locked to instance type/AZ.  
- **Convertible RIs**: Can change instance family (e.g., `m5` → `m6`) with lesser discount.  
**Key Notes**:  
- **Pricing**: 40-75% cheaper than On-Demand  
- **Commitment**: Requires upfront/all-upfront/partial payment  
- **Use Cases**: Steady-state workloads (e.g., production databases)  
**Example**: Reserve `c5.xlarge` for a 3-year term for a SaaS application.  

---

### **4. Savings Plans**  
**Definition**: Commit to consistent usage ($/hour) for 1/3 years for automatic discounts.  
**Types**:  
- **Compute SP**: Applies to EC2, Lambda, Fargate (most flexible).  
- **EC2 SP**: Specific to EC2 instance families.  
**Key Notes**:  
- **Pricing**: 50-72% discount vs. On-Demand  
- **Flexibility**: Automatically applies to any instance in the chosen family  
- **Use Cases**: Mixed workloads with variable instance needs  
**Example**: Commit to $10/hour for general-purpose instances.  

---

### **5. Dedicated Hosts**  
**Definition**: Physical servers dedicated to your use (no instance sharing).  
**Key Notes**:  
- **Pricing**: Most expensive (pay for entire host)  
- **Compliance**: Meets strict regulatory needs (e.g., HIPAA)  
- **Licensing**: Supports BYOL (e.g., Windows Server, SQL Server)  
**Example**: Hosting licensed software on `m5d.metal`.  

---

### **6. Capacity Reservations**  
**Definition**: Reserve capacity in a specific AZ without instance commitment.  
**Key Notes**:  
- **Pricing**: Same as On-Demand (no discount)  
- **Flexibility**: Can be combined with RIs/Savings Plans  
- **Use Cases**: Mission-critical apps needing guaranteed capacity  
**Example**: Reserve `g4dn.xlarge` in `us-east-1a` for ML inference.  

---

### **Comparison Cheat Sheet**  
| **Option**          | **Cost Savings** | **Flexibility** | **Best For**                | **Risk**                |  
|---------------------|------------------|-----------------|----------------------------|-------------------------|  
| On-Demand           | 0%               | ★★★★★           | Short-term/unpredictable    | None                    |  
| Spot                | 70-90%           | ★★☆☆☆           | Fault-tolerant workloads    | Sudden termination      |  
| Reserved (Standard) | 40-75%           | ★☆☆☆☆           | Predictable workloads       | Long-term commitment    |  
| Savings Plans       | 50-72%           | ★★★★☆           | Mixed workloads             | Moderate commitment     |  
| Dedicated Hosts     | 0%               | ★☆☆☆☆           | Compliance/licensing        | High cost               |  

---

### **Pro Tips**  
1. **Hybrid Approach**: Use RIs/Savings Plans for baseline + Spot for bursts.  
2. **Spot Interruption Handling**: Enable **hibernation** or checkpointing for stateful apps.  
3. **Region Matters**: Spot availability varies by region/AZ (check `ec2.DescribeSpotPriceHistory` API).  

**Need help modeling costs?** Try the [AWS Pricing Calculator](https://calculator.aws).  
