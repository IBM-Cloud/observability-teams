variable "ibmcloud_api_key" {
  description = "You IAM based API key. https://cloud.ibm.com/docs/iam?topic=iam-userapikey"
}

variable "region" {
  description = "The IBM Cloud region to deploy the resources under. "
  default = "us-east"
}

variable "resources_prefix" {
  description = "Prefix is added to all resources that are created by this template."
}

variable "resource_group" {
  description = "The resource group for all the resources created."
  default     = "default"
}

variable "monitoring_plan" {
  description = "Plan for your Monitoring instance in IBM Cloud."
  default = "graduated-tier"
}

variable "monitoring_instance_name" {
  description = "Name of your Monitoring instance in IBM Cloud."
  default = "monitoring"
}

variable "sysdig_tags" {
  default = "ibm.containers-kubernetes.cluster.id"
}

variable "team_go_name" {
  default     = "Team Go"
}

variable "team_go_description" {
  default     = "Go team with limited visibility"
}

variable "team_go_show" {
  default     = "container"
}

variable "team_go_theme" {
  default     = "#7FD5EA"
}

variable "team_go_filter" {
  default     = "kubernetes.deployment.name in (\"go-app-deployment\")"
}

variable "team_go_members" {
  type    = list
}

variable "team_go_access_scope" {
  default     = "app:go-app"
}

variable "team_node_name" {
  default     = "Team Node"
}

variable "team_node_description" {
  default     = "Node.js team with limited visibility"
}

variable "team_node_show" {
  default     = "container"
}

variable "team_node_theme" {
  default     = "#43853D"
}

variable "team_node_filter" {
  default     = "kubernetes.deployment.name in (\"node-app-deployment\")"
}

variable "team_node_members" {
  type    = list
}

variable "team_node_access_scope" {
  default     = "app:node-app"
}

variable "cluster_id" {
  description = "ID for Kubernetes cluster in IBM Cloud."
}

variable "go_app_name" {
  description = "name used for the chart name, team filter, etc..."
  default = "go-app"
}

variable "go_image_repository" {
  description = "Location of the go image in the the image Container Registry."
}

variable "node_app_name" {
  description = "name used for the chart name, team filter, etc..."
  default = "node-app"
}

variable "node_image_repository" {
  description = "Location of the node image in the the image Container Registry."
}

variable "logdna_service_key" {
  default = ""
}

variable "activity_tracker_service_key" {
  default = ""
}

variable "cluster_access_scope" {
  default = "host:containers-kubernetes"
}

variable "team_cluster_name" {
  default     = "Team Cluster"
}

variable "activity_tracker_instance_name" {
  description = "Name of your Activity Tracker instance in IBM Cloud."
  default = "activity-tracker"
}

variable "team_cluster_members" {
  type    = list
}
