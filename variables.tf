variable "ibmcloud_api_key" {
  description = "You IAM based API key. https://cloud.ibm.com/docs/iam?topic=iam-userapikey"
}

variable "region" {
  description = "The IBM Cloud region to deploy the resources under. "
  default = "us-south"
}

variable "resources_prefix" {
  description = "Prefix is added to all resources that are created by this template."
}

variable "resource_group" {
  description = "The resource group for all the resources created."
  default     = "default"
}

variable "sysdig_plan" {
  description = "Plan for your Sysdig instance in IBM Cloud."
  default = "graduated-tier"
}

variable "sysdig_instance_name" {
  description = "Name of your Sysdig instance in IBM Cloud."
  default = "sysdig-monitoring"
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
  default     = "kubernetes.deployment.name in (\\\"go-app-deployment\\\")"
}

variable "team_go_members" {
  default    = []
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
  default     = "kubernetes.deployment.name in (\\\"node-app-deployment\\\")"
}

variable "team_node_members" {
  default    = []
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