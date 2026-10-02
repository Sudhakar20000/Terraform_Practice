variable "project" {
    type = string
    default = "amazon"
} 

variable "env" {
    type = string
    default = "dev"
} 

variable "cidrs_frounttir" {
    type = list
    default = [ "10.0.1.0/24" , "10.0.2.0/24" ]
}

variable "cidrs_apptir" {
    type = list
    default = [ "10.0.11.0/24" , "10.0.12.0/24" ]
}

variable "cidrs_dbtir" {
    type = list
    default = [ "10.0.21.0/24" , "10.0.22.0/24" ]
}