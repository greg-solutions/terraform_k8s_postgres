module "postgres" {
  source = "../"
  nfs_endpoint = "nfs_url"
  image = "postgres:12.2"
  db_password = "password"
  namespace = "namespace"
  mount_path = "/var/postgres/"
  service_type = "ClusterIP"
  #env = []
/*
  volume_nfs = [
    {
      path_on_nfs = ""
      nfs_endpoint = ""
      volume_name = ""
    }
  ]
    volume_mount = [
    {
      mount_path = ""
      sub_path = ""
      volume_name = ""
    }
  ]
}
*/