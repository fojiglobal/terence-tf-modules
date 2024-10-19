######### DNS variable Record ######################
resource "aws_route53_record" "staging" {
  zone_id = var.dns_zone # #data.aws_route53_zone.terence24labs.zone_id
  name    = var.dns_name # "staging.terence24labs.com"
  type    = var.dns_record_type

  alias {
    name                   =  var.dns_name
    zone_id                =  var.dns_zone
    evaluate_target_health = true
  }
}

resource "aws_route53_health_check" "staging" {
  port              = 80
  type              = "HTTP"
  failure_threshold = "5"
  request_interval  = "30"

  tags = {
    Name = "staging-health-check"
  }
}