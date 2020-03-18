data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "sysdig" {
  name       = "sysdig-agent"
  namespace  = "ibm-observe"
  chart      = "stable/sysdig"
  wait       = true
  set {
    name  = "sysdig.accessKey"
    value = ibm_resource_key.resource_key.credentials["Sysdig Access Key"]
  }
  set {
    name  = "sysdig.settings.tags"
    value = "${var.sysdig_tags}:${var.cluster_infrastructure == "vpc" ? data.ibm_container_vpc_cluster.cluster[0].cluster_name_id : data.ibm_container_cluster.cluster[0].cluster_name_id}"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
  set {
    name = "sysdig.settings.collector"
    value = "ingest.${var.region}.monitoring.cloud.ibm.com"
  }
  set {
    name = "sysdig.settings.collector_port"
    value = "6443"
  }
  set {
    name = "sysdig.settings.k8s_cluster_name"
    value = "${var.cluster_infrastructure == "vpc" ? data.ibm_container_vpc_cluster.cluster[0].resource_name : data.ibm_container_cluster.cluster[0].resource_name}/{${var.cluster_infrastructure == "vpc" ? data.ibm_container_vpc_cluster.cluster[0].cluster_name_id : data.ibm_container_cluster.cluster[0].cluster_name_id}}" #"k8s-standard-02/bphqej9d0spngroitd40"
  }  
  set {
    name = "sysdig.settings.ssl"
    value = true
  }
  set {
    name = "sysdig.settings.ssl_verify_certificate"
    value = true
  }
  set {
    name = "sysdig.settings.prometheus.enabled"
    value = true
  }  
  set {
    name = "sysdig.settings.new_k8s"
    value = true
  }  
}