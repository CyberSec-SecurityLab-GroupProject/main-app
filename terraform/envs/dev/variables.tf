variable "project" {
  type    = string
  default = "breachbeach"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "breachbeach"
    Env     = "dev"
    LabID   = "lab001"
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}