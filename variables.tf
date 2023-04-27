variable "domain_name" {
  type    = string
  default = "numbersappecs.tk"
}

variable "subdomain" {
  type    = string
  default = "argo"
}
# variable subdomain {
#   description = "Subdomain per environment"
#   type        = map(string)
#   default = {
#     prod       = "prod"
#     staging    = "staging"
#     dev        = "dev"
#   }
# }

variable "lb_dns_name" {
  description = "Aplication load balancer dns name"
  default     = null
}
