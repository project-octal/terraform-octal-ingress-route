variable "name" {
  type        = string
  description = "The name of this ingress route"
}
variable "namespace" {
  type        = string
  description = "The name of the namespace this ingress route will reside in"
}
variable "labels" {
  type        = map(string)
  description = "A map of string to add to use as the labels for this resource"
}
variable "cert_issuer" {
  type        = string
  description = "The certificate issuer used to create this certificate"
}
variable "dns_name" {
  type = string
}
variable "entrypoints" {
  type        = list(string)
  description = "A list of entry points for this service."
  default     = ["websecure"]
}
variable "route_rules" {
  type = list(object({
    match_rule : string,
    middlewares : list(object({
      name : string,
      namespace : string
    }))
    services : list(object({
      name : string,
      namespace : string,
      port : number,
      scheme : string
    }))
  }))
}