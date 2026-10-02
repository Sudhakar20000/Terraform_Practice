resource "aws_iam_role" "bastion_role" {
  name = "${local.common_name}-bastion"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })


tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-bastion"
}
)
}

resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.bastion_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${local.common_name}-bastion"
  role = aws_iam_role.bastion_role.name
}