# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.provision 'shell', path: 'bootstrap/bootstrap_vagrant.sh'
  config.vm.synced_folder "../some_folder", "/project"
end
