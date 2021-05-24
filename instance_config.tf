resource "ibm_resource_instance" "logging" {
  name              = "${var.resources_prefix}-logging"
  resource_group_id = data.ibm_resource_group.group.id
  service           = "logdna"
  plan              = "7-day"
  location          = var.region
}

resource "ibm_resource_key" "logging_key" {
  name                 = "${var.resources_prefix}-logging-key"
  resource_instance_id = ibm_resource_instance.logging.id
  role                 = "Manager"
}

resource "ibm_ob_logging" "logging" {
  cluster              = var.cluster_id
  instance_id          = ibm_resource_instance.logging.guid
  logdna_ingestion_key = ibm_resource_key.logging_key.credentials["ingestion_key"]
  private_endpoint     = true

  depends_on = [ibm_resource_key.logging_key]
}

resource "ibm_resource_instance" "monitoring" {
  name              = "${var.resources_prefix}-${var.monitoring_instance_name}"
  service           = "sysdig-monitor"
  plan              = var.monitoring_plan
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
}

resource "ibm_resource_key" "monitoring_key" {
  name                 = "${var.resources_prefix}-sysdig-resource-key"
  role                 = "Administrator"
  resource_instance_id = ibm_resource_instance.monitoring.id
}

resource "ibm_ob_monitoring" "monitoring" {

  cluster           = var.cluster_id
  instance_id       = ibm_resource_instance.monitoring.guid
  sysdig_access_key = ibm_resource_key.monitoring_key.credentials["Sysdig Access Key"]
  private_endpoint  = true

  depends_on = [ibm_resource_key.monitoring_key]
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
  roles           = ["Viewer"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":", ibm_resource_instance.monitoring.id), 7)
  }
}

resource "ibm_iam_access_group_policy" "go_group_policy_2" {
  access_group_id = ibm_iam_access_group.go_group.id
  roles           = ["Reader"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":", ibm_resource_instance.monitoring.id), 7)

    attributes = {
      "sysdigTeam" = sysdig_monitor_team.team_go.id
    }
  }
}

resource "ibm_iam_access_group_policy" "go_group_policy_3" {
  access_group_id = ibm_iam_access_group.go_group.id
  roles           = ["Viewer"]

  resources {
    service              = "logdna"
    resource_instance_id = element(split(":", ibm_resource_instance.logging.id), 7)
  }
}

resource "ibm_iam_access_group_policy" "go_group_policy_4" {
  access_group_id = ibm_iam_access_group.go_group.id
  roles           = ["Reader"]

  resources {
    service              = "logdna"
    resource_instance_id = element(split(":", ibm_resource_instance.logging.id), 7)

    attributes = {
      "logGroup" = var.team_go_name
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
  roles           = ["Viewer"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":", ibm_resource_instance.monitoring.id), 7)
  }
}

resource "ibm_iam_access_group_policy" "node_group_policy_2" {
  access_group_id = ibm_iam_access_group.node_group.id
  roles           = ["Reader"]

  resources {
    service              = "sysdig-monitor"
    resource_instance_id = element(split(":", ibm_resource_instance.monitoring.id), 7)

    attributes = {
      "sysdigTeam" = sysdig_monitor_team.team_node.id
    }
  }
}

resource "ibm_iam_access_group_policy" "node_group_policy_3" {
  access_group_id = ibm_iam_access_group.node_group.id
  roles           = ["Viewer"]

  resources {
    service              = "logdna"
    resource_instance_id = element(split(":", ibm_resource_instance.logging.id), 7)
  }
}

resource "ibm_iam_access_group_policy" "node_group_policy_4" {
  access_group_id = ibm_iam_access_group.node_group.id
  roles           = ["Reader"]

  resources {
    service              = "logdna"
    resource_instance_id = element(split(":", ibm_resource_instance.logging.id), 7)

    attributes = {
      "logGroup" = var.team_node_name
    }
  }
}

resource "null_resource" "logging_create_group_1" {
  count = var.logging_service_key != "" ? 1 : 0

  provisioner "local-exec" {
    command     = "./scripts/at-logging-instance-external.sh"
    interpreter = ["bash", "-c"]

    environment = {
      config_directory   = "/tmp"
      region             = var.region
      service_key = var.logging_service_key

      group_name         = var.team_node_name
      group_access_scope = "app:${var.node_app_name}"
    }
  }

  depends_on = [ibm_resource_key.logging_key]
}

resource "null_resource" "logging_create_group_2" {
  count = var.logging_service_key != "" ? 1 : 0

  provisioner "local-exec" {
    command     = "./scripts/at-logging-instance-external.sh"
    interpreter = ["bash", "-c"]

    environment = {
      config_directory = "/tmp"
      region           = var.region
      service_key      = var.logging_service_key

      group_name         = var.team_go_name
      group_access_scope = "app:${var.go_app_name}"
    }
  }

  depends_on = [
    ibm_resource_key.logging_key,
    null_resource.logging_create_group_1
  ]
}

data "ibm_resource_instance" "activity_tracker" {
  name              = var.activity_tracker_instance_name
  location          = var.region
  resource_group_id = data.ibm_resource_group.group.id
  service           = "logdnaat"
}

resource "null_resource" "activity_tracker_create_group" {
  count = var.activity_tracker_service_key != "" ? 1 : 0

  provisioner "local-exec" {
    command     = "./scripts/at-logging-instance-external.sh"
    interpreter = ["bash", "-c"]

    environment = {
      config_directory = "/tmp"
      region           = var.region
      service_key      = var.activity_tracker_service_key

      group_name         = var.team_cluster_name
      group_access_scope = "app:${data.ibm_container_vpc_cluster.cluster[0].crn}"
    }
  }
}

resource "ibm_iam_access_group" "cluster_group" {
  name        = var.team_cluster_name
  description = "Cluster access group for Activity Tracker team"
}

resource "ibm_iam_access_group_members" "cluster_group" {
  access_group_id = ibm_iam_access_group.cluster_group.id
  ibm_ids         = var.team_cluster_members
}

resource "ibm_iam_access_group_policy" "cluster_group_policy_1" {
  access_group_id = ibm_iam_access_group.cluster_group.id
  roles           = ["Viewer"]

  resources {
    service              = "logdnaat"
    resource_instance_id = element(split(":", data.ibm_resource_instance.activity_tracker.id), 7)
  }
}

resource "ibm_iam_access_group_policy" "cluster_group_policy_2" {
  access_group_id = ibm_iam_access_group.cluster_group.id
  roles           = ["Reader"]

  resources {
    service              = "logdnaat"
    resource_instance_id = element(split(":", data.ibm_resource_instance.activity_tracker.id), 7)

    attributes = {
      "logGroup" = var.team_cluster_name
    }
  }
}
