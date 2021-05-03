resource "ibm_resource_instance" "monitoring" {
  name              = "${var.resources_prefix}-${var.sysdig_instance_name}"
  service           = "sysdig-monitor"
  plan              = var.sysdig_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
}

# resource "ibm_iam_service_id" "service_id" {
#   name        = "${var.resources_prefix}-${var.sysdig_instance_name}-key-admin"
#   description = "Service ID for ${ibm_resource_instance.monitoring.guid}"
# }

# resource "time_sleep" "wait_30_seconds" {
#   depends_on = [ibm_iam_service_id.service_id]

#   create_duration = "30s"
# }

resource "ibm_resource_key" "monitoring_key" {
  name                 = "${var.resources_prefix}-sysdig-resource-key"
  role                 = "Administrator"
  resource_instance_id = ibm_resource_instance.monitoring.id
  # parameters = {
  #   "serviceid_crn" = ibm_iam_service_id.service_id.crn
  # }
  # depends_on = [time_sleep.wait_30_seconds]
}

resource "sysdig_monitor_team" "team_go" {
  name        = var.team_go_name
  description = var.team_go_description
  scope_by    = var.team_go_show
  # theme        = var.team_go_theme
  filter = var.team_go_filter

  can_see_infrastructure_events = true

  entrypoint {
    type = "Explore"
  }

  # need to keep the key so that we can delete the teams
  depends_on = [
    ibm_resource_key.monitoring_key,
    data.ibm_iam_auth_token.tokendata,
    ibm_resource_instance.monitoring
  ]
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
    resource_instance_id = element(split(":",ibm_resource_instance.monitoring.id),7)
  }
}

resource "ibm_iam_access_group_policy" "go_group_policy_2" {
  access_group_id = ibm_iam_access_group.go_group.id
  roles        = ["Reader"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":",ibm_resource_instance.monitoring.id),7)

    attributes = {
      "sysdigTeam" = sysdig_monitor_team.team_go.id
    }
  }
}

resource "sysdig_monitor_team" "team_node" {
  name        = var.team_node_name
  description = var.team_node_description
  scope_by    = var.team_node_show
  # theme        = var.team_node_theme
  filter = var.team_node_filter

  can_see_infrastructure_events = true

  entrypoint {
    type = "Explore"
  }

  # need to keep the key so that we can delete the teams
  depends_on = [
    ibm_resource_key.monitoring_key,
    data.ibm_iam_auth_token.tokendata,
    ibm_resource_instance.monitoring
  ]
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
    resource_instance_id = element(split(":",ibm_resource_instance.monitoring.id),7)
  }
}

resource "ibm_iam_access_group_policy" "node_group_policy_2" {
  access_group_id = ibm_iam_access_group.node_group.id
  roles        = ["Reader"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":",ibm_resource_instance.monitoring.id),7)

    attributes = {
      "sysdigTeam" = sysdig_monitor_team.team_node.id
    }
  }
}
