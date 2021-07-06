terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "= 1.24.0"
    }
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 0.5.14"
    }
    external   = ">= 1.2.0"
    helm       = ">= 1.0.0"
    kubernetes = ">= 1.11.1"
    time       = ">= 0.7.0"
  }
  required_version = ">= 0.12"
}
