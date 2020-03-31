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

resource "ibm_is_vpc" "vpc" {
  count = var.cluster_infrastructure == "vpc" ? 1 : 0

  name           = "${var.resources_prefix}-vpc"
  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_subnet" "sub" {
  count = var.cluster_infrastructure == "vpc" ? 3 : 0

  name                     = "${var.resources_prefix}-sub-${count.index + 1}"
  vpc                      = ibm_is_vpc.vpc[0].id
  zone                     = var.vpc_zones["${var.region}-availability-zone-${count.index + 1}"]
  total_ipv4_address_count = 16

  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_is_security_group_rule" "sg_inbound_tcp_30000_32767" {
  count = var.cluster_infrastructure == "vpc" ? (var.generation == 2 ? 3 : 0) : 0

  group     = ibm_is_vpc.vpc[0].default_security_group
  direction = "inbound"
  remote    = element(ibm_is_subnet.sub.*.ipv4_cidr_block, count.index)

  tcp {
    port_min = 30000
    port_max = 32767
  }
}