resource "k8s_manifest" "ingress_certificate" {
  content = yamlencode(local.ingress_certificate)
}
locals {
  ingress_certificate = {
    apiVersion = "cert-manager.io/v1"
    kind = "Certificate"
    metadata = {
      name = "${var.name}.traefik-tls"
      namespace = var.namespace
      labels = local.labels
    }
    spec = {
      commonName = var.dns_name
      secretName = "${var.name}.traefik-tls"
      dnsNames = [
        var.dns_name
      ]
      issuerRef = {
        name = var.cert_issuer
        kind = "ClusterIssuer"
      }
    }
  }
}