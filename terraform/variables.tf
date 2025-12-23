variable "location" {
  default = "eastus2"
}

variable "resource_group_name" {
  default = "rg-cloud-demo"
}

variable "vnet_address_space" {
  default = "10.10.0.0/16"
}

variable "acr_name" {
  description = "Nombre único del ACR"
}

variable "aks_name" {
  default = "aks-cloud-demo"
}

variable "mysql_admin_user" {
  default = "mysqladmin"
}

variable "mysql_admin_password" {
  sensitive = true
}

variable "mysql_db_name" {
  default = "cloudapp"
}
