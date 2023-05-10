terraform {
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

# There are currently no configuration options for the provider itself.

resource "virtualbox_vm" "node" {
  count     = 3
  name      = format("node-%02d", count.index + 1)
  # Chose a box on vagrant cloud
  image     = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20230425.0.0/providers/virtualbox.box"
  cpus      = 2
  memory    = "512 mib"

  network_adapter {
    type           = "bridged"
    # Use this cmd to chose one : VBoxManage list bridgedifs
    host_interface = "Intel(R) Dual Band Wireless-AC 8260"
    
    #type           = "hostonly"
    # Find name in virtualbox host network manager
    #host_interface = "VirtualBox Host-Only Ethernet Adapter"
  }
}

output "IPAddr" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 1)
}

output "IPAddr_2" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 2)
}

output "IPAddr_3" {
  value = element(virtualbox_vm.node.*.network_adapter.0.ipv4_address, 3)
}