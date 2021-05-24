data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_container_vpc_cluster" "cluster" {
  count             = 1
  name              = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id

}

data "ibm_container_cluster_config" "clusterConfig" {
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = "/tmp"
}

provider "kubernetes" {
  config_path = data.ibm_container_cluster_config.clusterConfig.config_file_path
}

resource "kubernetes_namespace" "ibm_observe" {
  metadata {
    name = "ibm-observe"
  }
}

provider "helm" {
  debug = true

  kubernetes {
    config_path = data.ibm_container_cluster_config.clusterConfig.config_file_path
  }
}
