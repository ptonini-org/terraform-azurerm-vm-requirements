variable "name" {}

variable "rg" {}

variable "host_count" {}

variable "subnet_id" {}

variable "public_ip" {}

variable "network_rules" {
  type    = map(any)
  default = {}
}
variable "high_availability" {
  default = false
}

variable "cloudinit_config" {
  type = object({
    gzip          = optional(bool)
    base64_encode = optional(bool, true)
    parts = map(object({
      filename     = optional(string)
      content      = string
      content_type = optional(string)
    }))
  })
  default = null
}