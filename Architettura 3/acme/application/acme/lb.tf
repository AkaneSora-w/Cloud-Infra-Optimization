#################################
# ALB Listener & Target Groups
#################################
resource "aws_lb_target_group" "acme" {

  vpc_id               = var.networking.vpc_id
  name                 = local.prefix
  slow_start           = 30
  deregistration_delay = 20
  protocol             = "HTTP"
  port                 = var.acme_tg_cfg.port

  target_type = "instance"

  health_check {
    interval          = 30
    path              = var.acme_tg_cfg.health_check_path
    port              = var.acme_tg_cfg.port
    protocol          = "HTTP"
    timeout           = 5
    healthy_threshold = 5
    matcher           = "404"
  }
  stickiness {
    enabled = true
    type    = "lb_cookie"
  }
}

resource "aws_lb_listener_rule" "acme_rule" {
  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.acme.arn
  }

  condition {
    host_header {
      values = var.acme_tg_cfg.domain_names
    }
  }
}

resource "aws_lb_target_group_attachment" "ec2_acme" {
  target_group_arn = aws_lb_target_group.acme.arn
  target_id        = module.ec2_acme.id
  port             = var.acme_tg_cfg.port
}

resource "aws_lb_target_group_attachment" "ec2_acme_clone" {
  count            = var.ec2_acme_config["acme_clone"].create ? 1 : 0
  target_group_arn = aws_lb_target_group.acme.arn
  target_id        = module.ec2_acme_clone.id
  port             = var.acme_tg_cfg.port
}

#################################
# Collaudo acme rules
#################################

resource "aws_lb_listener_rule" "collaudo_acme_rule" {
  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.acme.arn
  }

  condition {
    host_header {
      values = var.acme_tg_cfg.collaudo_domain_names
    }
  }
}

#################################
# Formazione acme rules
#################################

resource "aws_lb_listener_rule" "formazione_acme_rule" {

  count = length(var.acme_tg_cfg.formazione_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.acme.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }


  condition {
    host_header {
      values = var.acme_tg_cfg.formazione_domain_names
    }
  }
}

#################################
# Backoffice acme rules
#################################

resource "aws_lb_listener_rule" "backoffice_acme_rule" {

  count = length(var.acme_tg_cfg.formazione_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.acme.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    host_header {
      values = var.acme_tg_cfg.backoffice_domain_names
    }
  }
}

#################################
# Zefiro acme rules
#################################

resource "aws_lb_listener_rule" "zefiro_acme_rule" {

  count = length(var.acme_tg_cfg.zefiro_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.acme.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    host_header {
      values = var.acme_tg_cfg.zefiro_domain_names
    }
  }
}

#################################
# Jakala acme rules
#################################

resource "aws_lb_listener_rule" "jakala_acme_rule" {

  count = length(var.acme_tg_cfg.jakala_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.acme.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    host_header {
      values = var.acme_tg_cfg.jakala_domain_names
    }
  }
}

#################################
# Connector api 2 acme rules
#################################

resource "aws_lb_listener_rule" "connector_api_2_acme_rule" {

  count = length(var.acme_tg_cfg.connector_api2_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.acme.arn
        weight = 1
      }

      stickiness {
        enabled  = false
        duration = 3600
      }
    }
  }

  condition {
    host_header {
      values = var.acme_tg_cfg.connector_api2_domain_names
    }
  }
}