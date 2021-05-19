data "ibm_resource_group" "group" {
  name = var.resource_group
}

resource "ibm_is_vpc" "vpc" {
  count = 1

  name           = "${var.resources_prefix}-vpc"
  resource_group = data.ibm_resource_group.group.id
}

data "ibm_is_zones" "zones" {
  region = var.region
}

resource "ibm_is_public_gateway" "pgw" {
  count = length(data.ibm_is_zones.zones.zones)
  name  = "${var.resources_prefix}-pgw-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc[0].id
  zone  = element(data.ibm_is_zones.zones.zones, count.index)
  resource_group = data.ibm_resource_group.group.id
}


resource "ibm_is_subnet" "sub" {
  count = length(data.ibm_is_zones.zones.zones)

  name                     = "${var.resources_prefix}-sub-${count.index}"
  vpc                      = ibm_is_vpc.vpc[0].id
  zone                     = element(data.ibm_is_zones.zones.zones, count.index)
  total_ipv4_address_count = 16
  public_gateway           = element(ibm_is_public_gateway.pgw.*.id, count.index)

  resource_group = data.ibm_resource_group.group.id
}

resource "ibm_container_vpc_cluster" "cluster" {
  name = "${var.resources_prefix}-cluster"

  vpc_id            = ibm_is_vpc.vpc[0].id
  flavor            = var.flavor
  worker_count      = var.worker_count
  resource_group_id = data.ibm_resource_group.group.id
  kube_version      = var.kube_version

  zones {
    subnet_id = ibm_is_subnet.sub[0].id
    name      = ibm_is_subnet.sub[0].zone
  }
  # zones {
  #   subnet_id = ibm_is_subnet.sub[1].id
  #   name      = ibm_is_subnet.sub[1].zone
  # }
  # zones {
  #   subnet_id = ibm_is_subnet.sub[2].id
  #   name      = ibm_is_subnet.sub[2].zone
  # }
}