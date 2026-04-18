#generates a JSON policy document
data "aws_iam_policy_document" "read_db_secret" {
  statement {
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [var.db_master_secret_arn]
    effect    = "Allow"
  }
}

#Create IAM Policy
resource "aws_iam_policy" "read_db_secret" {
  name   = "${var.name}-read-db-secret"
  policy = data.aws_iam_policy_document.read_db_secret.json
}
#Create IAM Role
resource "aws_iam_role" "myrole" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#Attach policy to the role
resource "aws_iam_role_policy_attachment" "app_read_db_secret" {
  role       = aws_iam_role.myrole.name
  policy_arn = aws_iam_policy.read_db_secret.arn
}


#attach role to profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.name}-ec2-profile"
  role = aws_iam_role.myrole.name
}