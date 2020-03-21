resource "aws_lb" "lb_app_frontend" {
  name               = "lb-app-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.sg_web}"]
  subnets            = ["${var.sn_web1}","${var.sn_web2}"]

  enable_deletion_protection = true

  tags = {
    Environment = "demo"
  }
}

resource "aws_alb_target_group" "tg_lb_app" {
  name     = "tg-lb-app"
  port     = 80  
  protocol = "HTTP"  
  vpc_id   = var.vpc_id  
  target_type = "instance" 
  stickiness {    
    type            = "lb_cookie"    
    cookie_duration = 8640    
    enabled         = "false"  
  }   
  health_check {    
    enabled = true
    healthy_threshold = 5
    interval = 30
    matcher = "200"
    path =  "/index.php"
    port = "80"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2  
  }
}

resource "aws_lb_listener" "lb_listener_front_end" {
  load_balancer_arn = aws_lb.lb_app_frontend.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_lb_app.arn
  }
}
