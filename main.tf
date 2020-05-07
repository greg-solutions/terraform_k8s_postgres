resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace == true ? 1 : 0
  metadata {
    annotations = {
      name = var.namespace
    }
    name = var.namespace
  }
}

module "deploy" {
  source = "git::https://github.com/greg-solutions/terraform_k8s_statefulset.git"
  name = var.app_name
  namespace = var.create_namespace == true ? kubernetes_namespace.namespace[0].id : var.namespace
  image = local.image
  internal_port = var.ports
  volume_host_path = var.volume_host_path
  volume_config_map = var.volume_config_map
  env = local.env
}

module "service" {
  source = "git::https://github.com/greg-solutions/terraform_k8s_service.git"
  app_name = var.app_name
  app_namespace = var.create_namespace == true ? kubernetes_namespace.namespace[0].id : var.namespace
  port_mapping = var.ports
  type = var.service_type
}
