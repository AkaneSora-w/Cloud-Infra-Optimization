variable "cloudfront_aliases" {
  description = "alias for cloudfront"
  type = list(string)
  default = [ "tesi.awslab.epsilonline.com", 
    "www.tesi.awslab.epsilonline.com" ]
}

variable "ec2_instances" {
  description = "public dns and work env of ec2 for cloudfrfont"
  type = map(object({
    public_dns = string
    work_env = string
  }))
  default = {}
}