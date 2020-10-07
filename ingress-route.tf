resource "k8s_manifest" "ingress_route" {
  content = yamlencode(local.dashboard_ingress_route)
}
locals {
  dashboard_ingress_route = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind = "IngressRoute"
    metadata = {
      name = var.name
      namespace = var.namespace
      labels = merge({
        "app.kubernetes.io/managed-by" = "Terraform"
      }, var.labels)
    }
    spec = {
      entryPoints = var.entrypoints
      routes = [ for route in var.route_rules :
      {
        kind = "Rule"
        match = route["match_rule"]
        services = [ for service in route["services"] :
        {
          kind = "Service"
          name = service["name"]
          namespace = service["namespace"]
          port = service["port"]
          scheme = "https"
        }
        ]
      }
      ]
      tls = {
        secretName: local.ingress_certificate.metadata.name
      }
    }
  }
}