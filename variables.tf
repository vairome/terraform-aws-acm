variable "domain_name" {
  type    = string
  default = "numbersappecs.tk"
}

variable "subdomain" {
  type    = string
  default = "numbersappecs-argo"
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
   default = "k8s-mlflow-mymlflow-3ce8e5287e-1639301570.us-east-1.elb.amazonaws.com"
}
