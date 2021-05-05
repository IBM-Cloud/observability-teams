# resource "helm_release" "sysdig" {
#   name       = "ibm-community"
#   repository = "https://raw.githubusercontent.com/IBM/charts/master/repo/community"

#   chart      = "sysdig"
#   namespace  = "ibm-observe"
  
#   wait = true

#   set {
#     name  = "sysdig.accessKey"
#     value = ibm_resource_key.monitoring_key.credentials["Sysdig Access Key"]
#   }
#   set {
#     name  = "sysdig.settings.tags"
#     value =  "${var.sysdig_tags}:${data.ibm_container_vpc_cluster.cluster[0].name}"
#   }
#   set {
#     name  = "image.tag"
#     value = "latest"
#   }
#   set {
#     name  = "sysdig.settings.collector"
#     value = "ingest.${var.region}.monitoring.cloud.ibm.com"
#   }
#   set {
#     name  = "sysdig.settings.collector_port"
#     value = "6443"
#   }
#   set {
#     name  = "sysdig.settings.k8s_cluster_name"
#     value = "${data.ibm_container_vpc_cluster.cluster[0].resource_name}/${data.ibm_container_vpc_cluster.cluster[0].name}"
#   }
#   set {
#     name  = "sysdig.settings.ssl"
#     value = true
#   }
#   set {
#     name  = "sysdig.settings.ssl_verify_certificate"
#     value = true
#   }
#   set {
#     name  = "sysdig.settings.prometheus.enabled"
#     value = true
#   }
#   set {
#     name  = "sysdig.settings.new_k8s"
#     value = true
#   }
# }


