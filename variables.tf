variable vpc_cidr {
  default = "10.30.0.0/16"
}

variable pub_sbn_a {
  default = "10.30.1.0/24"
}

variable pub_sbn_b {
  default = "10.30.2.0/24"
}

variable prefix {
  default = "TF-PoC-Add-10-svc"
}

variable ec2_key{
  default = "Terraform-PoV"
}

variable Operation {
  default = "LIVE"
}

variable Service {
  default = "NASMO"
}