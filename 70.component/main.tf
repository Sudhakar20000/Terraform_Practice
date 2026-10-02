module "components" {
    for_each = var.components
    source = "../Component_module"
    env = var.env
    component = each.key
    app_version = each.value.app_version
    rule_priority = each.value.rule_priority
}