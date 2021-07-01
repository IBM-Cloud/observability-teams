resource "helm_release" "go_app" {
  name       = "teams-${var.go_app_name}"
  namespace  = "default"
  chart      = "./samples/${var.go_app_name}/chart/${var.go_app_name}"
  wait       = true

  set {
    name  = "replicaCount"
    value = 3
  }

  set {
    name  = "image.repository"
    value = var.go_image_repository
  }

  set {
    name  = "ingress.name"
    value = "${var.go_app_name}-ingress"
  }

  set {
    name  = "ingress.host"
    value = "teams-${var.go_app_name}.${data.ibm_container_vpc_cluster.cluster[0].ingress_hostname}"
  }

  set {
    name  = "ingress.tls.hosts"
    value = "teams-${var.go_app_name}.${data.ibm_container_vpc_cluster.cluster[0].ingress_hostname}"
  }

  set {
    name  = "ingress.tls.secret_name"
    value = data.ibm_container_vpc_cluster.cluster[0].ingress_secret
  }

  depends_on = [ 
    data.ibm_container_cluster_config.clusterConfig
  ]
}

resource "helm_release" "node_app" {
  name       = "teams-${var.node_app_name}"
  namespace  = "default"
  chart      = "./samples/${var.node_app_name}/chart/${var.node_app_name}"
  wait       = true

  set {
    name  = "replicaCount"
    value = 3
  }

  set {
    name  = "image.repository"
    value = var.node_image_repository
  }

  set {
    name  = "ingress.name"
    value = "${var.node_app_name}-ingress"
  }

  set {
    name  = "ingress.host"
    value = "teams-${var.node_app_name}.${data.ibm_container_vpc_cluster.cluster[0].ingress_hostname}"
  }

  set {
    name  = "ingress.tls.hosts"
    value = "teams-${var.node_app_name}.${data.ibm_container_vpc_cluster.cluster[0].ingress_hostname}"
  }

  set {
    name  = "ingress.tls.secret_name"
    value = data.ibm_container_vpc_cluster.cluster[0].ingress_secret
  }

  depends_on = [ 
    data.ibm_container_cluster_config.clusterConfig
  ]
}