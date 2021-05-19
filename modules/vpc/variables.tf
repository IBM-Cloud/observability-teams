# ---------------------------------------------------- #
# REQUIRED
# These variables are expected to be passed in
# ---------------------------------------------------- #

variable "ibmcloud_api_key" {
  description = "You IAM based API key. https://cloud.ibm.com/docs/iam?topic=iam-userapikey"
  type        = string
}

variable "resources_prefix" {
  description = "Prefix is added to all resources that are created by this template."
  type        = string
}

# ---------------------------------------------------- #
# OPTIONAL A
# These variables have good enough defaults for most.
# ---------------------------------------------------- #

variable "region" {
  description = "The IBM Cloud region to deploy the resources under."
  type        = string
  default = "us-south"
}

variable "resource_group" {
  description = "The resource group for all the resources created."
  default     = "default"
}

# ---------------------------------------------------- #
# OPTIONAL B
# These variables do not need to change.
# ---------------------------------------------------- #

variable "worker_count" {
  default = 2
}

variable "flavor" {
  default = "cx2.4x8"
}

variable "kube_version" {
  default = "1.20.6"
}