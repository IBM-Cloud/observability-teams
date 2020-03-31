terraform {
  required_version = ">= 0.12.23"
}

provider "ibm" {
  version          = ">= 1.2.4"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 300
  generation       = var.generation
}

data "ibm_resource_group" "group" {
  name = var.resource_group
}

resource "ibm_container_vpc_cluster" "cluster" {
  count = var.cluster_infrastructure == "vpc" ? 1 : 0

  name = "${var.resources_prefix}-cluster"

  vpc_id            = var.vpc_id
  flavor            = var.flavor
  worker_count      = var.worker_count
  resource_group_id = data.ibm_resource_group.group.id
  kube_version      = var.kube_version

  zones {
    subnet_id = var.subnets["zone-1"]
    name      = var.vpc_zones["${var.region}-availability-zone-1"]
  }
  zones {
    subnet_id = var.subnets["zone-2"]
    name      = var.vpc_zones["${var.region}-availability-zone-2"]
  }
  zones {
    subnet_id = var.subnets["zone-3"]
    name      = var.vpc_zones["${var.region}-availability-zone-3"]
  }
}

resource "ibm_container_cluster" "cluster" {
  count = var.cluster_infrastructure == "classic" ? 1 : 0

  name            = "${var.resources_prefix}-cluster"
  datacenter      = var.datacenter
  machine_type    = var.flavor
  hardware        = "shared"
  public_vlan_id  = var.public_vlan_id
  private_vlan_id = var.private_vlan_id
  subnet_id       = ["1154643"]

  default_pool_size      = 1
}


# data "ibm_container_vpc_cluster" "cluster" {
#   count = var.cluster_infrastructure == "vpc" ? 1 : 0
#   cluster_name_id   = var.cluster_id
#   resource_group_id = data.ibm_resource_group.group.id
# }

# data "ibm_container_cluster" "cluster" {
#   count = var.cluster_infrastructure == "classic" ? 1 : 0
#   cluster_name_id   = var.cluster_id
#   resource_group_id = data.ibm_resource_group.group.id
# }

# data "ibm_container_cluster_config" "clusterConfig" {
#   cluster_name_id   = var.cluster_id
#   resource_group_id = data.ibm_resource_group.group.id
#   config_dir        = "/tmp"
# }
