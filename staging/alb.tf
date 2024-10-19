############# Application Load Balancer Reource ##########
# resource "aws_lb_listener" "http_https" {
#   load_balancer_arn = aws_lb.arn
#   #port              = "80"
#   #protocol          = "HTTP"
 
#   port = var.http_port
#   protocol = var.http_protocol

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = var.https_port
#       protocol    = var.https_protocol
#       status_code = "HTTP_301"
#     }
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Fixed response content"
#       status_code  = "200"
#     }
#   }
# }

# resource "aws_lb_listener_rule" "staging_rule" {
#   listener_arn = aws_lb_listener.front_end.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.static.arn
#   }
#   condition {
#     host_header {
#       values = ["terence24labs.com"]
#     }
#   }
# }
########@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
resource "aws_lb_target_group" "tg" {
  name     = "${var.env}-tg-80"
  port     = var.http_port
  protocol = var.http_protocol
  vpc_id   = aws_vpc.this.id
  health_check {
    healthy_threshold = 2
    interval = 10
  }
}

resource "aws_lb" "alb" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  tags = {
    Name = "${var.env}-alb"
    Environment = var.env
  }
}
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn  # Use the alb_ssl_cert_arn variable here

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


resource "aws_lb_listener" "http_to_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.https_protocol
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "https" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    host_header {
      values = var.alb_rule_condition #["stage.terence24labs.com", "www.stage.terence24labs.com"]
    }
  }
}