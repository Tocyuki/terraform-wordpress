resource "aws_iam_role" "web" {
  name               = "service-role-${var.name}-web"
  path               = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_instance_profile" "web" {
  name = "${var.name}_web_profile"
  role = aws_iam_role.web.name
}

resource "aws_iam_role_policy_attachment" "ssm_for_web" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "s3_for_web" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
