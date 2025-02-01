# infrastructure-as-code-with-terraform
Use Terraform to provision infrastructure like EC2 instances, databases, and load balancers.

# Infrastructure as Code (IaC) with Terraform

This project demonstrates how to use Terraform to provision infrastructure on AWS, including EC2 instances, databases, and load balancers.

---

## Prerequisites

Before running Terraform, make sure you have the following:

- **Terraform** installed on your local machine (see the installation guide below).
- **AWS CLI** configured with your AWS credentials (access keys).
- **A text editor** (e.g., Visual Studio Code) for editing Terraform files.

---

## Install Terraform on macOS

### Using Homebrew

1. **Install Homebrew** (if it's not already installed):
   Open your terminal and run the following command:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Terraform**:
   Once Homebrew is installed, install Terraform with this command:
   ```bash
   brew tap hashicorp/tap
   brew install hashicorp/tap/terraform
   ```

3. **Verify Terraform Installation**:
   Check if Terraform is installed by running:
   ```bash
   terraform -v
   ```
   This should return the installed version of Terraform.

---

## Create the `main.tf` File

Once Terraform is installed, create a new directory for your Terraform configuration files and create a `main.tf` file in that directory.

Example `main.tf` to provision an AWS EC2 instance:

```hcl
# Provider configuration
provider "aws" {
  region = "us-east-1"  # Change to your desired region
}

# EC2 Instance resource
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"  # Choose an instance type

  tags = {
    Name = "ExampleInstance"
  }
}

# Security Group for allowing SSH access
resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh"
  description = "Allow SSH access to EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**Note**: Change the `ami` value to a valid AMI ID for your AWS region. You can find this on the [AWS EC2 AMI page](https://aws.amazon.com/amazon-linux-2/).

## Summary of the main.tf
- **Terraform Block**: 
Specifies the required Terraform version and provider versions.

- **Provider Block**: Configures AWS as the cloud provider and sets the region.

- **Security Group**: Creates a security group that allows SSH access (port 22) from a specified IP range (var.ssh_access_cidr), with an open egress rule for all outbound traffic.

- **EC2 Instance**: Creates an EC2 instance using a provided AMI, instance type, and SSH key, and associates it with the security group defined earlier.

- **Outputs**: Displays the public IP and public DNS of the EC2 instance after deployment.

---

### **Understanding `variables.tf` and `terraform.tfvars` in Terraform**

#### **What is `variables.tf`?**
The `variables.tf` file in Terraform is where you define the variables that your infrastructure code will use. This file serves as a **centralized location** for specifying the **type**, **description**, and **default values** of the variables. It defines the **structure** and **expected inputs** for your infrastructure, making your Terraform configuration clearer and more organized.

Example of a variable definition in `variables.tf`:
```hcl
# variables.tf
variable "aws_region" {
  description = "The AWS region to deploy infrastructure in"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

- `description`: Provides a human-readable explanation of what the variable does.
- `type`: Defines what type of value is expected (e.g., `string`, `number`, `list`).
- `default`: Specifies a default value for the variable (optional). If no value is provided, Terraform will use this default.

#### **Why is `variables.tf` Needed?**
1. **Clarity and Documentation**: By defining variables in `variables.tf`, you document **what inputs** your Terraform configuration requires. This makes the configuration easier to understand and manage, especially for teams.
   
2. **Centralized Configuration**: It provides a centralized place to manage all the variables, making it easier to track and modify them in the future.

3. **Validation and Type Safety**: You can enforce variable types (e.g., `string`, `number`, `list`) and validation rules to ensure the correct data is passed. This reduces human error.

4. **Separation of Concerns**: `variables.tf` separates the definition of variables from the provisioning logic in `main.tf`, leading to cleaner and more modular code.

#### **What is `terraform.tfvars`?**
`terraform.tfvars` is a file where you provide **actual values** for the variables defined in `variables.tf`. This file allows you to customize the configuration for different environments (e.g., development, staging, production) without changing the code in `main.tf` or `variables.tf`.

For example, the `terraform.tfvars` file might look like this:
```hcl
# terraform.tfvars
aws_region    = "us-east-1"
instance_type = "t2.medium"
```

#### **How Do `variables.tf` and `terraform.tfvars` Work Together?**
- **`variables.tf`** defines **what variables are needed**, their **types**, **descriptions**, and optional **default values**.
- **`terraform.tfvars`** provides the **actual values** for those variables. If a variable is not specified in `terraform.tfvars`, Terraform will use the default value from `variables.tf` (if defined).

For example, if `aws_region` is defined in `variables.tf` with a default value of `us-west-2`, but `terraform.tfvars` specifies `us-east-1`, Terraform will use `us-east-1` instead of the default.

#### **Why Use Both `variables.tf` and `terraform.tfvars`?**
1. **Flexibility**: The combination of `variables.tf` and `terraform.tfvars` allows you to keep your Terraform configurations **flexible**. You can easily change values for different environments without modifying the code, just by updating the `terraform.tfvars` file.
   
2. **Separation of Concerns**: `variables.tf` defines **what** variables exist and **what type of data** they expect, while `terraform.tfvars` allows you to define the **actual values** that Terraform will use.

3. **Clarity and Maintenance**: `variables.tf` makes it clear what inputs are required, and `terraform.tfvars` allows you to **separate the environment-specific values** from the code, improving the maintainability of the Terraform configurations.

#### **In Summary:**
- **`variables.tf`**: Defines the structure of your variables—what they are, what type they should be, and their descriptions. It makes the code modular, clear, and reusable.
- **`terraform.tfvars`**: Provides the actual values for those variables, allowing you to customize configurations without altering the core logic of the code.
  
This separation makes your Terraform code more **flexible**, **scalable**, and **easier to manage**, especially in larger projects or when working with multiple environments.

---

## Terraform Commands

### 1. **Initialize Terraform**

Before running any Terraform commands, initialize the project to download necessary provider plugins.

```bash
terraform init
```

### 2. **Plan the Infrastructure**

Terraform provides a `plan` command that shows you what changes it will make to your infrastructure. Run this to preview the changes:

```bash
terraform plan
```

### 3. **Apply the Configuration**

Once you've reviewed the plan, you can apply the configuration to provision the infrastructure:

```bash
terraform apply
```

Terraform will ask for confirmation before applying the changes. Type `yes` to proceed.

### 4. **Destroy the Infrastructure**

To clean up and remove all the resources that Terraform provisioned, run:

```bash
terraform destroy
```

Again, it will prompt for confirmation before proceeding. Type `yes` to delete the resources.

---

## Troubleshooting

- If you encounter issues with AWS credentials, make sure you've configured your AWS CLI using `aws configure` with your access and secret keys.
- Ensure that your AWS IAM user has sufficient permissions to provision the resources in your `main.tf` file.

---
