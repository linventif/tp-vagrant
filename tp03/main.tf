terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = "3.0.0"
    }
  }
}

resource "openstack_compute_instance_v2" "vm1" {
  name = "vm1"
  image_name = "ubuntu22.04"
  flavor_name = "petite"
}
