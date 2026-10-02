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
    default = [ "mongodb" , "redis" ]
}