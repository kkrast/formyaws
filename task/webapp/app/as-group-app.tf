resource "aws_autoscaling_group" "as-app" {
    desired_capacity          = 0
    health_check_grace_period = 300
    health_check_type         = "EC2"
    max_size                  = 2
    min_size                  = 1
    name                      = "as-app"
    vpc_zone_identifier       = ["${var.sn_web1}","${var.sn_web2}"]

    tag {
        key   = "ASG"
        value = "as-app"
        propagate_at_launch = true
    }
    launch_template {
        id      = aws_launch_template.lt_app_inst.id
        version = "$Latest"
    }

}

resource "aws_autoscaling_attachment" "as_app_attach_tg_lb_app" {
  autoscaling_group_name = "as-app"
  alb_target_group_arn   = aws_alb_target_group.tg_lb_app.arn
}