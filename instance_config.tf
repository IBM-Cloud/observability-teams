resource "ibm_resource_instance" "sysdig" {
  name              = "${var.resources_prefix}-${var.sysdig_instance_name}"
  service           = "sysdig-monitor"
  plan              = var.sysdig_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
}

resource "ibm_iam_service_id" "service_id" {
  name        = "${var.resources_prefix}-${var.sysdig_instance_name}-key-admin"
  description = "Service ID for ${ibm_resource_instance.sysdig.guid}"
}

resource "ibm_resource_key" "resource_key" {
  name                 = "${var.resources_prefix}-sysdig-resource-key"
  role                 = "Administrator"
  resource_instance_id = ibm_resource_instance.sysdig.id
  parameters = {
    "serviceid_crn" = ibm_iam_service_id.service_id.crn
  }
}

data "external" "sysdig_instance" {
  program = ["bash", "./scripts/sysdig-instance-external.sh"]

  query = {
    config_directory  = "config"
    region            = var.region
    IBMInstanceID     = ibm_resource_instance.sysdig.guid
    resource_group_id = data.ibm_resource_group.group.id
    ibmcloud_api_key  = var.ibmcloud_api_key
    
    team_go_name         = var.team_go_name
    team_go_description  = var.team_go_description
    team_go_show         = var.team_go_show
    team_go_theme        = var.team_go_theme
    team_go_filter       = var.team_go_filter

    team_node_name         = var.team_node_name
    team_node_description  = var.team_node_description
    team_node_show         = var.team_node_show
    team_node_theme        = var.team_node_theme
    team_node_filter       = var.team_node_filter    
  }
}

resource "ibm_iam_access_group" "go_group" {
  name        = var.team_go_name
  description = "Go access group for Sysdig team"
}

resource "ibm_iam_access_group_members" "go_group" {
  access_group_id = ibm_iam_access_group.go_group.id
  ibm_ids         = var.team_go_members
}

resource "ibm_iam_access_group_policy" "go_group_policy" {
  access_group_id = ibm_iam_access_group.go_group.id
  roles        = ["Viewer"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":",ibm_resource_instance.sysdig.id),7)
  }
}

resource "ibm_iam_access_group_policy" "go_group_policy_2" {
  access_group_id = ibm_iam_access_group.go_group.id
  roles        = ["Reader"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":",ibm_resource_instance.sysdig.id),7)

    attributes = {
      "sysdigTeam" = data.external.sysdig_instance.result.team_go_teamId
    }
  }
}

resource "ibm_iam_access_group" "node_group" {
  name        = var.team_node_name
  description = "Node access group for Sysdig team"
}

resource "ibm_iam_access_group_members" "node_group" {
  access_group_id = ibm_iam_access_group.node_group.id
  ibm_ids         = var.team_node_members
}

resource "ibm_iam_access_group_policy" "node_group_policy_1" {
  access_group_id = ibm_iam_access_group.node_group.id
  roles        = ["Viewer"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":",ibm_resource_instance.sysdig.id),7)
  }
}

resource "ibm_iam_access_group_policy" "node_group_policy_2" {
  access_group_id = ibm_iam_access_group.node_group.id
  roles        = ["Reader"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":",ibm_resource_instance.sysdig.id),7)

    attributes = {
      "sysdigTeam" = data.external.sysdig_instance.result.team_node_teamId
    }
  }
}
