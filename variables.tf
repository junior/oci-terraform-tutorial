variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {
  default = ""
}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}

variable "shape" {
  default = "VM.Standard2.1"
}