variable "env" {
  description = "awsのprofile"
  default     = "dev"
}

variable "org_name" {
  description = "Organization Name"
}

variable "ref_prefix" {
  default = "*"
}