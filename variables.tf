variable "prefix" {
  type        = string
  description = "prefix to attach before each resource name"
}

variable "location" {
  type        = string
  description = "Azure region in which the resource will be created"
}

variable "username" {
  type        = string
  description = "Username for the VM"
  default     = "azureadmin"
}

variable "backend_pool_node_count" {
  type        = number
  description = "Count of VMs that will be created as a backend address pool for the load balancer"
  default     = 2
}