data "template_file" "awsconfig_iam_role" {
  template = "${file("${path.module}/templates/awsconfig_iam_role.json")}"
}

data "template_file" "awsconfig_iam_role_policy" {
  template = "${file("${path.module}/templates/awsconfig_iam_role_policy.json")}"
}

resource "aws_iam_role" "awsconfig" {
  name               = "my-awsconfig-role"
  assume_role_policy = data.template_file.awsconfig_iam_role.rendered
}

resource "aws_iam_role_policy" "awsconfig" {
  name   = "my-awsconfig-policy"
  role   = aws_iam_role.awsconfig.id
  policy = data.template_file.awsconfig_iam_role_policy.rendered
}

resource "aws_config_config_rule" "awsconfig" {
  name = "${var.name}-${var.env}-awsconfig-rule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = [aws_config_configuration_recorder.awsconfig]
}

resource "aws_config_configuration_recorder" "awsconfig" {
  name     = "${var.name}-${var.env}-awsconfig-recorder"
  role_arn = aws_iam_role.awsconfig.arn
}
