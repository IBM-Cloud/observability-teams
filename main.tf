terraform {
  required_version = ">= 0.12.23"

  required_providers {
    external   = ">= 1.2.0"
    helm       = ">= 1.0.0"
    kubernetes = ">= 1.11.1"
  }
}

provider "ibm" {
  version          = ">= 1.2.3"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 300
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

data "ibm_container_cluster" "cluster" {
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
}

data "ibm_container_cluster_config" "clusterConfig" {
  cluster_name_id   = var.cluster_id
  resource_group_id = data.ibm_resource_group.group.id
  config_dir        = "/tmp"
}

provider "kubernetes" {
  load_config_file = true
  config_path      = data.ibm_container_cluster_config.clusterConfig.config_file_path
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
