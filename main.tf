###########################################################
###
### This Terraform Script will install an architecture that includes:
###
### A) SAP App Server Cluster
###    1) Resource
###    2) VNet / Subnet
###    3) VMs
###
###########################################################

provider "azurerm" {
  version = "~> 2.20.0"

  features {
    
  }
}

###########################################################
###
### Definition of Resource Group
###
###########################################################

resource "azurerm_resource_group" "lab1" {
  name = format("%s%s%s01" ,var.prefix, var.resource_group_name, var.env)
  location = var.location
  tags = {
    expiration_date = var.expiration_date
    created_by = "terraform_script"
  }
}

###########################################################
###
### Definition of Network Resources and Properties
###
###########################################################

resource "azurerm_virtual_network" "lab1" {
  name = format("%s%s%s01" ,var.prefix, var.vnet_name, var.env)
  address_space = [ var.vnet_address_space ]
  location = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
}

# Subnet definition for VNET
resource "azurerm_subnet" "lab1" {
  name = format("%s%s%s01" ,var.prefix, var.subnet_name_1, var.env)
  resource_group_name = azurerm_resource_group.lab1.name
  virtual_network_name = azurerm_virtual_network.lab1.name
  address_prefixes = [ var.subnet_address_prefix_1 ]
}

###########################################################
###
### Deployment of the Virtual Machine in Availability Set
###     1) Public IP
###     2) Standard Load Balancer
###     3) NIC
###     4) Managed Disks
###     5) PPG
###     6) Availability Set
###     7) VMs
###########################################################

resource "azurerm_public_ip" "lab1" {
  name = format("%s%s%s01" ,var.prefix, var.public_id_1, var.env)
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  allocation_method = "Static"
}

resource "azurerm_lb" "lab1" {
  name = format("%s%s%s01" ,var.prefix, var.slb_1, var.env)
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  
  frontend_ip_configuration {
    name = "publicIpAddress"
    public_ip_address_id = azurerm_public_ip.lab1.id
  }
}

resource "azurerm_network_interface" "lab1" {
  count               = 2
  name                = format("%s%s%s%s" ,var.prefix, var.nic_name, var.env, count.index)
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name

  ip_configuration {
    name                          = "ipConfiguration1"
    subnet_id                     = azurerm_subnet.lab1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_managed_disk" "lab1" {
  count = 2
  name = "datadisk_existing_${count.index}"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_proximity_placement_group" "lab1" {
  name = "ppg1"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
}

resource "azurerm_availability_set" "lab1"{
  name = "avset1"
  location            = azurerm_resource_group.lab1.location
  resource_group_name = azurerm_resource_group.lab1.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  proximity_placement_group_id = azurerm_proximity_placement_group.lab1.id
  managed                      = true
}


resource "azurerm_virtual_machine" "lab1" {
  count = 2
  name                  = format("%s%s%s%s" ,var.prefix, var.virtual_machine_name, var.env,count.index)
  location              = azurerm_resource_group.lab1.location
  resource_group_name   = azurerm_resource_group.lab1.name
  availability_set_id   = azurerm_availability_set.lab1.id
  network_interface_ids = [element(azurerm_network_interface.lab1.*.id, count.index)]
  vm_size               = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.image_publisher #"Canonical"
    offer     = var.image_offer #"UbuntuServer"
    sku       = var.image_sku #"16.04-LTS"
    version   = var.image_version #"latest"
  }

  storage_os_disk {
    name              = lower(format("%s%s%s%s" ,var.prefix, var.vm_os_disk, var.env,count.index))
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.vm_hostname
    admin_username = var.vm_username
    admin_password = var.vm_username_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  tags = {
    expiration_date = var.expiration_date
    created_by = "terraform_script"
  }

}

