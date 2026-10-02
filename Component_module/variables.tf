variable "project" {
    type = string
    default = "amazon"
}

variable "env" {
    type = string
    default = "dev"
}

variable "app_version" {
    default = "v3"
}

variable "component" {
    type = string
}

variable "rule_priority" {
    #type = string
}

variable "domain" {
    type = string
    default = "sudhakar.shop"
}