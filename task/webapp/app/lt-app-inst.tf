data "template_file" "app_server_user_data" {
  template = "${file("${path.module}/app_user_data")}"
}


resource "aws_launch_template" "lt_app_inst" {
  name = "lt-app-inst"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      delete_on_termination = true
      encrypted = false
      volume_size = 50
      volume_type = "gp2"
    }
  }

  disable_api_termination = false

  image_id = data.aws_ami.amazon-linux-ami.id

  instance_type = "t2.micro"

  key_name = "my-key-pair"

  vpc_security_group_ids = ["${var.sg_web}"]

  tag_specifications {
       resource_type = "instance"
       tags = {
         Name = "AppServer"
	     Role = "AppServer"
       }
  }
	
  tag_specifications {
       resource_type = "volume"
       tags = {
         Name = "AppServer"
	     Role = "AppServer"
       }
   }
  

  user_data = base64encode(data.template_file.app_server_user_data.rendered)
}