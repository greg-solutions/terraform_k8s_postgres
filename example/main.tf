module "postgres" {
  source = "../"
  nfs_endpoint = local.nfs_url
  custom_image = true
  image = "postgres:12.2"
}