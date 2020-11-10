data "template_file" "init_script" {
  template = file("${path.module}/scripts/init.sh")

  vars = {
    efs_id      = aws_efs_file_system.web.id
    system_name = var.name
  }
}

resource "aws_launch_template" "web" {
  name                   = "${var.name}-${var.env}-web-template"
  image_id               = data.aws_ami.web.id
  vpc_security_group_ids = [aws_security_group.web.id]
  instance_type          = var.instance_type
  key_name               = aws_key_pair.web.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.web.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = format("%s-%s-web", var.name, var.env),
      Role = "web"
    })
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.common_tags, {
    Name = format("%s-%s-web-launch-template", var.name, var.env)
  })

  user_data = base64encode(data.template_file.init_script.rendered)
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.name}-${var.env}-asg"
  max_size            = 4
  desired_capacity    = 2
  min_size            = 2
  force_delete        = true
  health_check_type   = "ELB"
  target_group_arns   = [aws_alb_target_group.web.arn]
  vpc_zone_identifier = var.private_subnets[*].id

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "web_scale_out" {
  name                   = "${var.name}-${var.env}-web-Instance-ScaleOut-CPU-High"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "web_scale_in" {
  name                   = "${var.name}-${var.env}-web-Instance-ScaleIn-CPU-Low"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
