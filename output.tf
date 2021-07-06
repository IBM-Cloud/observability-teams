output "database_instances_access" {
  value = <<APPS
  
  ### You can access the Node.js application using the following URL :
        http://teams-${var.node_app_name}.${data.ibm_container_vpc_cluster.cluster[0].ingress_hostname}

  ### You can access the Go application using the following URL :
        http://teams-${var.go_app_name}.${data.ibm_container_vpc_cluster.cluster[0].ingress_hostname}

  --------------------------------------------------------------------------------
    
APPS

}