variable "app_name" {
  description = "(Optional) Application name"
  default = "postgres"
}
variable "create_namespace" {
  description = "(Optional) Default 'false' value will create namespace in cluster. If you want use exist namespace set 'false'"
  default = true
}
variable "ports" {
  description = "(Optional) Port mapping"
  default = [
    {
      name = "db-ports"
      internal_port = "5432"
      external_port = "5432"
      nodeport = "30543"
    }
  ]
}
variable "nfs_endpoint" {}
variable "nfs_path" {
  default = "/"
}
variable "volume_config_map" {
  description = "(Optional) Create ConfigMap volume"
  default = []
}
variable "volume_host_path" {
  description = "(Optional) Create HostPath volume"
  default = []
}
variable "custom_envs" {
  description = "(Required) true or fasle if true then for call module should be specified env vars"
  default = false
}
variable "db_password" {
  description = "(Default) must be overriden by custom password"
  default = "SuperSecurePassword012!"
}
variable "namespace" {
  default = ""
}
variable "custom_image" {
  description = "(Required) true or fasle if true then for call module should be specified image with tag"
  default = false
}
variable "image" {
  default = ""
}
locals {
  image = "postgres:12"
  namespace = var.create_namespace == true ? "postgres" : var.namespace
  env = var.custom_envs == true ? null : [
    {
      name = "POSTGRES_DB"
      value = "postgres"
    },
    {
      name = "POSTGRES_ENCODING"
      value = "UTF8"
    },
    {
      name = "POSTGRES_PASSWORD"
      value = var.custom_envs == true ? null : var.db_password
    },
    {
      name = "POSTGRES_USER"
      value = "postgres"
    }
  ]
}