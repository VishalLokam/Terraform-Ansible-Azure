# Overview
Create a VM cluster with private IP to act as a backend address pool for a load balancer. User a jump box with public IP which has Ansible installed to do configuration management on the VM cluster. User interacts with the load balancer and the load balancer translates the private IP addresses of the backend address pool to public IP address

# Architecture
![Architecture Diagram](https://github.com/VishalLokam/VM-cluster-Azure-Ansible/blob/main/Assets/azure_terraform_ansible_architecture.png)

# Current implementation
Running this project will create the following resources on Microsoft Azure:-
- `SSH key` to be used by all the VM's for Ansible configuration from the jump box to the backend pool  
- `Resource group` containing all the Azure resources
- `Networking` for the VMs
    - `Virtual network` to host all the VMs
    - `Subnet` subnet inside `Virtual network` along with the subnet rules
- `Load balancer` Users will connect to this load balancer  
    - `Health check probes` for checking VM health
    - `Load balance rules` to govern access rules allowed/denied by the load balancer
- `Virtual machines` for the backend pool for the load balancer as well as one that will act as a jump box for anisble configuration
    - `Availability set` to set fault domain and update domain
    - `Network Interface cards` virtual NICs to be associated with the VMs
    - `Virtual machine extension` runs the shell script to update dependencies and install ansible
- `Public IP` for the load balancer and the jump box

# Execution Steps
1. Create a new file `terraform.tfvars` and place the below content in it.
    ```
    prefix                  = "<prefix_to_attach_before_each_resource>"
    location                = "<desired_location>"
    username                = "<VMs_username>"
    backend_pool_node_count = <backend_pool_VM_count>
    ```

2. Run the below commands
    ```
    terraform init
    terraform plan
    terraform apply -auto-approve
    ```



