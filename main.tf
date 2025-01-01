resource "azurerm_availability_set" "this" {
  count               = var.high_availability ? 1 : 0
  name                = "${var.name}-as"
  resource_group_name = var.rg.name
  location            = var.rg.location
  managed             = true
}

module "security_group" {
  source        = "app.terraform.io/ptonini-org/network-security-group/azurerm"
  version       = "~> 1.0.0"
  name          = "${var.name}-sg"
  rg            = var.rg
  network_rules = var.network_rules
}

module "network_interface" {
  source            = "app.terraform.io/ptonini-org/network-interface/azurerm"
  version           = "~> 1.0.0"
  count             = var.host_count
  name              = "${var.name}${format("%04.0f", count.index + 1)}-net-interface"
  rg                = var.rg
  subnet_id         = var.subnet_id
  public_ip         = var.public_ip
  security_group_id = module.security_group.this.id
}

data "cloudinit_config" "this" {
  count         = length(var.cloudinit_config[*])
  gzip          = var.cloudinit_config.gzip
  base64_encode = var.cloudinit_config.base64_encode

  dynamic "part" {
    for_each = var.cloudinit_config.parts
    content {
      filename     = coalesce(part.value.filename, part.key)
      content      = part.value.content
      content_type = part.value.content_type
    }
  }
}