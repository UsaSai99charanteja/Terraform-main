data "aws_ssm_parameter" "three_tier_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_launch_template" "front_app" {
  name_prefix = "front_app"
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.three_tier_ami.value
  vpc_security_group_ids = [var.front_end_sg]

}

resource "aws_autoscaling_group" "front_app" {
  name = "front_app"
  vpc_zone_identifier = var.public_subnets
  min_size = 2
  max_size = 3
  desired_capacity = 2

  launch_launch_template {
    id = aws_launch_template.front_app.id
    version = "$Latest"
  }  
}

resource "aws_launch_template" "back_app" {
  name_prefix = "back_app"
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.three_tier_ami.value
  vpc_security_group_ids = [var.back_end_sg]
}

data "aws_lb_target_group" ""

resource "aws_autoscaling_group" "back_app" {
  name = "back_app"  
}