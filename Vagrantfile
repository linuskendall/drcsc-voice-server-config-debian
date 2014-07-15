# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "puppet-debian"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.10"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    # Don't boot with headless mode
    #   vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    #   vb.customize ["modifyvm", :id, "--memory", "1024"]
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['modifyvm', :id, '--usbehci', 'on']
    # will be required for usb connections
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'HUAWEI Mobile', '--vendorid', '0x12d1']
  end

  config.vm.synced_folder "~/drcsc-voice/", "/drcsc-voice"

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.

  config.vm.provision "shell", inline: "puppet module install puppetlabs-mysql"
  config.vm.provision "shell", inline: "puppet module install puppetlabs-apache"
  config.vm.provision "shell", inline: "puppet module install puppetlabs-vcsrepo"
  config.vm.provision "shell", inline: "puppet module install example42-php"
  config.vm.provision "shell", inline: "puppet module install example42-perl"
  config.vm.provision "shell", inline: "puppet module install maestrodev-wget"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path = "modules"
    #puppet.options = "--verbose --debug"
  end
end
