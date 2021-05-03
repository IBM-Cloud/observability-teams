provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 300
}

data "ibm_iam_auth_token" "tokendata" {}
