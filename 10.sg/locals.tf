locals {
    common_name = "${var.project}-${var.env}-${var.sg_name}"
    common_tags = {
        Name      = local.common_name
        terraform = "true"
    }
}
