variable "project" {
    type = string
    default = "amazon"
} 

variable "env" {
    type = string
    default = "dev"
} 

variable "sg_name" {
    type = list
    default = [ "mongodb", "redis", "mysql", "rabbitmq",
        "catalogue", "user", "cart", "shipping", "payment",
        "backend_alb",
        "frontend",
        "frontend_alb",
        "bastion"  ]
}