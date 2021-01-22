terraform {
  required_version = ">= 0.13.0"
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region           = var.region
}

resource "oci_core_instance" "tutorial_instance" {
  shape               = "VM.Standard2.1"
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = local.compartment_ocid
  display_name = ""

  source_details {
    source_id   = lookup(data.oci_core_images.compute_images.images[0], "id")
    source_type = "image"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.tutorial_subnet.id
    display_name     = "Primaryvnic"
    assign_public_ip = true
    hostname_label   = "tfexampleinstance"
  }
}

resource "oci_core_vcn" "tutorial_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = local.compartment_ocid
  display_name   = "TutorialVcn"
  dns_label      = "tutorialvcn"
}

resource "oci_core_subnet" "tutorial_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.1.20.0/24"
  display_name        = "TestSubnet"
  dns_label           = "testsubnet"
  security_list_ids   = [oci_core_vcn.tutorial_vcn.default_security_list_id]
  compartment_id      = local.compartment_ocid
  vcn_id              = oci_core_vcn.tutorial_vcn.id
  route_table_id      = oci_core_vcn.tutorial_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.tutorial_vcn.default_dhcp_options_id
}

data "oci_core_images" "compute_images" {
  compartment_id           = local.compartment_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  shape                    = "VM.Standard2.1"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

locals {
  compartment_ocid = var.tenancy_ocid
}

variable "tenancy_ocid" {}
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
variable "region" {}