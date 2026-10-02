resource "aws_security_group" "sg" {
  count = length(var.sg_name)
  name        = "${var.project}-${var.env}-${var.sg_name[count.index]}"
  description = "Allow inbound web and SSH traffic"
  vpc_id      = aws_vpc.main.id 

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge (
    local.common_tags
    {
    Name = "${var.project}-${var.env}-${var.sg_name[count.index]}"
  }
  )
}