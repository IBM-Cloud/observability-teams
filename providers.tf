provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 900
}

data "ibm_iam_auth_token" "tokendata" {}

provider "sysdig" {
  # Configuration options
  sysdig_monitor_url       = ibm_resource_key.monitoring_key.credentials["Sysdig Endpoint"] #"https://${var.region}.monitoring.cloud.ibm.com"
  sysdig_monitor_api_token = data.ibm_iam_auth_token.tokendata.iam_access_token
  extra_headers = {
    IBMInstanceID = ibm_resource_instance.monitoring.guid
    Authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
  }
}