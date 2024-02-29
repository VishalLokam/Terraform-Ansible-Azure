# Overview
Create a VM cluster with private IP to act as a backend address pool for a load balancer. User a jump box with public IP which has Ansible installed to do configuration management on the VM cluster. User interacts with the load balancer and the load balancer translates the private IP addresses of the backend address pool to public IP address

# Architecture
![Architecture Diagram](https://github.com/VishalLokam/VM-cluster-Azure-Ansible/blob/main/Assets/azure_terraform_ansible_architecture.png)





