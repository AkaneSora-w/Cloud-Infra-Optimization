# module "records" {
#   source  = "terraform-aws-modules/route53/aws//modules/records"
#   version = "~> 2.0"

#   zone_id = var.networking.route53_zone_id

#   records = [
#     {
#       name = ""
#       type = ""
#       alias = {
#         name    = ""
#         zone_id = ""
#       }

#     }
#   ]
# }