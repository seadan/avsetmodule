
###########################################################
###
### This are the variables to use the rest of the script
###
###
###########################################################

variable "prefix"{
  type = string
  description = "This will be the prefix all resources will have"
  default = "E2SAP"
}

variable "env"{
  type = string
  description = "Environment: Dev, QA, Prod, Sbx, etc..."
  default = "D"
}

variable "location" {
  type        = string
  description = "Resource Location"
  default = "East US 2"
}

variable "cctag" {
  type        = string
  description = "Cost Center"
  default = "Microsoft ACOs"
}

variable "expiration_date" {
  type        = string
  description = "Cost Center"
  default = "20201204"
}

variable "resource_group_name" {
    type = string
    description = "Name of Resource Group"
    default = "RGAUT"
}

variable "vnet_name" {
  type        = string
  description = "Name of the Vnet"
  default = "VNETAUT"
}

variable "vnet_address_space" {
  type        = string
  description = "Address space for  the Vnet"
  default = "16.5.0.0/16"
}

variable "subnet_name_1" {
  type        = string
  description = "Name of the Vnet"
  default = "SUBNETAUT"
}


variable "subnet_address_prefix_1" {
  type        = string
  description = "address prefix of the SubNet"
  default = "16.5.1.0/24"
}

variable "subnet_address_prefix" {
  type    = list(string)
  default = ["16.5.1.0/24", "16.5.2.0/24"]
}


variable "nic_name" {
  type        = string
  description = "NIC Name"
  default = "NicName"
}

variable "virtual_machine_name" {
  type        = string
  description = "Virtual Machine Name"
  default = "VMAUT"
}

variable "vm_size" {
  type        = string
  description = "Virtual Machine Size"
  default = "Standard_D4d_v4"
}

variable "vm_hostname" {
  type        = string
  description = "Virtual Machine Name"
  default = "hostname"
}


variable "vm_username" {
  type        = string
  description = "Virtual Machine User Name"
  default = "adminadmin"
}

variable "vm_username_password" {
  type        = string
  description = "Virtual Machine User Name Password"
  default = "P.4ssw0rd!"
}

variable "image_publisher" {
  type        = string
  description = "Virtual Machine Image Publisher"
  default = "Canonical"
}

variable "image_offer" {
  type        = string
  description = "Virtual Machine Image SO"
  default = "UbuntuServer"
}

variable "image_sku" {
  type        = string
  description = "Virtual Machine Image Publisher SKU"
  default = "16.04-LTS"
}

variable "image_version" {
  type        = string
  description = "Virtual Machine Image Publisher Version"
  default = "latest"
}


variable "vm_os_disk" {
  type        = string
  description = "Virtual Machine OS Disk Name"
  default = "osdisk"
}

variable "av_set_name" {
  type        = string
  description = "Name of Availability Set"
  default = "AvSetSap"
}


variable "public_id_1" {
  type        = string
  description = "Name of Public Ip for SLB"
  default = "PIPSLB"
}


variable "slb_1" {
  type        = string
  description = "Name of Public Ip for SLB"
  default = "SLB"
}

