terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = ">= 1.23.2"
    }
    sysdig = {
      source  = "sysdiglabs/sysdig"
      version = ">= 0.5.14"
    }
    external   = ">= 1.2.0"
    helm       = ">= 1.0.0"
    kubernetes = ">= 1.11.1"
  }
  required_version = ">= 0.14.8"
}
