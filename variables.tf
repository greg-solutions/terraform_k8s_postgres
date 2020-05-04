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
variable "service_type" {
  description = "(Optional) service, available types ClusterIP, LoadBalancer, default type == NodePort"
  default = "NodePort"
}
variable "volume_config_map" {
  description = "(Optional) Create ConfigMap volume"
  default = []
}
variable "volume_host_path" {
  description = "(Optional) Create HostPath volume"
  default = []
}
variable "envs" {
  description = "(Optional) Can be overriden default env vars"
  default = []
}
variable "db_password" {
  description = "(Default) must be overriden by custom password"
  default = "SuperSecurePassword012!"
}
variable "namespace" {
  description = "(Optional) It's used in order to specify name of creating namespace or if 'createnamespace = false' name of existing namespace"
  default = "postgres"
}
variable "image" {
  description = "(Optional) Uses if needed to specify custom image"
  default = null
}
locals {
  image = var.image == null ? "postgres:12.2" : var.image
  env = var.envs == [] ? [
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
      value = var.db_password
    },
    {
      name = "POSTGRES_USER"
      value = "postgres"
    }
  ] : var.envs
  volume_nfs = var.volume_nfs == null ? [
    {
      path_on_nfs = var.nfs_path
      nfs_endpoint = var.nfs_endpoint
      volume_name = var.app_name
    }
  ] : var.volume_nfs

  volume_mount = var.volume_mount == null ? [
    {
      mount_path = var.mount_path
      sub_path = "${var.namespace}/${var.app_name}/data"
      volume_name = var.app_name
    }
  ] : var.volume_mount
}
variable "mount_path" {
  description = "(Optional) If specified then will be overriden and used custom mount path"
  default = "/var/lib/postgresql/data"
}
variable "volume_nfs" {
  description = "(Optional) Uses if needed to specify custom nfs volume"
  default = null
}
variable "volume_mount" {
  description = "(Optional) Uses if needed to specify custom volume mount"
  default = null
}
variable "nfs_endpoint" {}
variable "nfs_path" {
  description = "(Optional) works with default mount path"
  default = "/"
}