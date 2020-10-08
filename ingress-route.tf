resource "k8s_manifest" "ingress_route" {
  content = yamlencode(local.ingress_route)
}
locals {
  ingress_route = {
    apiVersion = "traefik.containo.us/v1alpha1"
    kind = "IngressRoute"
    metadata = {
      name = var.name
      namespace = var.namespace
      labels = var.labels
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
          scheme = service["scheme"]
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