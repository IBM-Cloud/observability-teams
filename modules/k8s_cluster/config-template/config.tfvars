ibmcloud_api_key = "<your_ibm_cloud_api_key>"

resource_group = "default"

region = "us-south"

resources_prefix = "<used_to_prefix_resources>"

generation = 1

flavor = "c2.2x4"

cluster_infrastructure = "vpc"

vpc_id = "<insert_vpc_id>"

subnets = {
    zone-1   = "<insert_subnet_id_zone_1>"
    zone-2   = "<insert_subnet_id_zone_2>"
    zone-3   = "<insert_subnet_id_zone_3>"
  }