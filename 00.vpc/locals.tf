locals {
    common_name = "${var.project}-${var.env}"
    common_tags = {
        Name      = local.common_name
        terraform = "true"
    }
    availablez = slice(data.aws_availability_zones.available.names, 0, 2)
}
