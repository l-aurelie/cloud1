#!/bin/bash

# echo "== Install Virtualbox"

# # Ajout de la clé GPG de VirtualBox
# wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
# # Ajout du dépôt VirtualBox à la liste des sources de logiciels Ubuntu
# echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

# # Installation de VirtualBox
# sudo apt update
# sudo apt install -y virtualbox-7.0



echo "== Install Terraform"

# Install dependencies
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
# Install the HashiCorp GPG key.
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
# Verify the key's fingerprint.
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

# Add the official HashiCorp repository to your system, lsb_release -cs finds the distribution release codename for your current system
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt-get install -y terraform


# UNINSTALL

# echo "== Uninstall Terraform"

# # Uninstall Terraform packages
# sudo apt-get remove terraform -y
# sudo apt-get purge terraform -y
# # Delete terraform conf files
# rm -rf ~/.terraformrc ~/.terraform.d/
# # Delete terraform plugins
# rm -rf ~/.terraform.d/plugins/
# # Delete terraform installation directory 
# sudo rm -rf /usr/local/bin/terraform
# # Delete unused dependencies 
# sudo apt-get autoremove -y
# echo "Terraform has been completely uninstalled" 


# echo "== Uninstall Virtualbox"

# # Stop all running VirtualBox VMs
# VBoxManage list runningvms | cut -d" " -f1 | xargs -I{} VBoxManage controlvm {} poweroff
# # Uninstall VirtualBox packages
# sudo apt-get remove --purge virtualbox virtualbox-dkms virtualbox-ext-pack virtualbox-guest-additions-iso virtualbox-guest-utils virtualbox-guest-x11
# # Remove VirtualBox configuration files
# sudo rm -rf ~/.config/VirtualBox
# sudo rm -rf ~/.VirtualBox
# # Remove VirtualBox kernel modules
# sudo dkms remove -m vboxhost -v $(VBoxManage -v | cut -dr -f1) --all
# sudo rm -rf /usr/src/vboxhost-$(VBoxManage -v | cut -dr -f1)
# echo "VirtualBox has been completely uninstalled."
