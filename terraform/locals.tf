locals {
  default_node_pool_config = yamldecode(file("./cluster_config/node_pools/default.yaml"))
  cluster_config           = yamldecode(file("./cluster_config/config.yaml"))
}