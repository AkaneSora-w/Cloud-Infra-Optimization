#################################
# ALB Listener & Target Groups
#################################
resource "aws_lb_target_group" "hcms" {

  vpc_id               = var.networking.vpc_id
  name                 = local.prefix
  slow_start           = 30
  deregistration_delay = 20
  protocol             = "HTTP"
  port                 = var.hcms_tg_cfg.port

  target_type = "instance"

  health_check {
    interval          = 30
    path              = var.hcms_tg_cfg.health_check_path
    port              = var.hcms_tg_cfg.port
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

resource "aws_lb_listener_rule" "hcms_rule" {
  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hcms.arn
  }

  condition {
    host_header {
      values = var.hcms_tg_cfg.domain_names
    }
  }
}

resource "aws_lb_target_group_attachment" "ec2_hcms" {
  target_group_arn = aws_lb_target_group.hcms.arn
  target_id        = module.ec2_hcms.id
  port             = var.hcms_tg_cfg.port
}

resource "aws_lb_target_group_attachment" "ec2_hcms_clone" {
  count            = var.ec2_hcms_config["hcms_clone"].create ? 1 : 0
  target_group_arn = aws_lb_target_group.hcms.arn
  target_id        = module.ec2_hcms_clone.id
  port             = var.hcms_tg_cfg.port
}

#################################
# Collaudo hcms rules
#################################

resource "aws_lb_listener_rule" "collaudo_hcms_rule" {
  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hcms.arn
  }

  condition {
    host_header {
      values = var.hcms_tg_cfg.collaudo_domain_names
    }
  }
}

#################################
# Formazione hcms rules
#################################

resource "aws_lb_listener_rule" "formazione_hcms_rule" {

  count = length(var.hcms_tg_cfg.formazione_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.hcms.arn
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
      values = var.hcms_tg_cfg.formazione_domain_names
    }
  }
}

#################################
# Backoffice hcms rules
#################################

resource "aws_lb_listener_rule" "backoffice_hcms_rule" {

  count = length(var.hcms_tg_cfg.formazione_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.hcms.arn
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
      values = var.hcms_tg_cfg.backoffice_domain_names
    }
  }
}

#################################
# Zefiro hcms rules
#################################

resource "aws_lb_listener_rule" "zefiro_hcms_rule" {

  count = length(var.hcms_tg_cfg.zefiro_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.hcms.arn
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
      values = var.hcms_tg_cfg.zefiro_domain_names
    }
  }
}

#################################
# Jakala hcms rules
#################################

resource "aws_lb_listener_rule" "jakala_hcms_rule" {

  count = length(var.hcms_tg_cfg.jakala_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.hcms.arn
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
      values = var.hcms_tg_cfg.jakala_domain_names
    }
  }
}

#################################
# Connector api 2 hcms rules
#################################

resource "aws_lb_listener_rule" "connector_api_2_hcms_rule" {

  count = length(var.hcms_tg_cfg.connector_api2_domain_names) > 0 ? 1 : 0

  listener_arn = var.networking.alb_public_https_listener_arn

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.hcms.arn
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
      values = var.hcms_tg_cfg.connector_api2_domain_names
    }
  }
}