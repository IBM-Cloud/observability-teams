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

variable "vpc_id" {
  default = ""
}

variable "cluster_infrastructure" {
  default = "vpc"
}

variable "generation" {
  description = "The VPC generation, currently supports Gen 1. Gen 2 tested in Beta."
  default     = 1
}

variable "resource_group" {
  description = "The resource group for all the resources created."
  default     = "default"
}

variable "worker_count" {
  default = 1
}

variable "flavor" {
  default = ""
}

variable "kube_version" {
  default = "1.17.4"
}

variable "subnets" {
  description = "The availability zone list for the VPC regions."

  default = {}
}

variable "vpc_zones" {
  description = "The availability zone list for the VPC regions."

  default = {
    au-syd-availability-zone-1   = "au-syd-1"
    au-syd-availability-zone-2   = "au-syd-2"
    au-syd-availability-zone-3   = "au-syd-3"
    eu-de-availability-zone-1    = "eu-de-1"
    eu-de-availability-zone-2    = "eu-de-2"
    eu-de-availability-zone-3    = "eu-de-3"
    eu-gb-availability-zone-1    = "eu-gb-1"
    eu-gb-availability-zone-2    = "eu-gb-2"
    eu-gb-availability-zone-3    = "eu-gb-3"
    jp-tok-availability-zone-1   = "jp-tok-1"
    jp-tok-availability-zone-2   = "jp-tok-2"
    jp-tok-availability-zone-3   = "jp-tok-3"
    us-south-availability-zone-1 = "us-south-1"
    us-south-availability-zone-2 = "us-south-2"
    us-south-availability-zone-3 = "us-south-3"
    us-east-availability-zone-1 = "us-east-1"
    us-east-availability-zone-2 = "us-east-2"
    us-east-availability-zone-3 = "us-east-3"
  }
}

variable "public_vlan_id" {
  default = ""
}

variable "private_vlan_id" {
  default = ""
}

variable "datacenter" {
  default = ""
}
