resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace == true ? 1 : 0
  metadata {
    annotations = {
      name = local.namespace
    }
    name = local.namespace
  }
}

module "deploy" {
  source = "git::https://github.com/greg-solutions/terraform_k8s_deploy.git"
  name = var.app_name
  namespace = var.create_namespace == true ? kubernetes_namespace.namespace[0].id : local.namespace
  image = var.custom_image == false ? local.image : var.image
  internal_port = var.ports
  volume_host_path = var.volume_host_path
  volume_config_map = var.volume_config_map
  volume_nfs = [
    {
      path_on_nfs = var.nfs_path
      nfs_endpoint = var.nfs_endpoint
      volume_name = var.app_name
    }
  ]
  volume_mount = [
    {
      mount_path = var.mount_path
      sub_path = "${local.namespace}/data"
      volume_name = var.app_name
    }
  ]
  env = local.env
}

module "service" {
  source = "git::https://github.com/greg-solutions/terraform_k8s_service.git"
  app_name = var.app_name
  app_namespace = var.create_namespace == true ? kubernetes_namespace.namespace[0].id : local.namespace
  port_mapping = var.ports
  type = "NodePort"
}
