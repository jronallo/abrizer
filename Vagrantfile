# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.box_version = "1.2.5"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.40"
    
  config.vm.synced_folder '.', '/vagrant'
  # , type: 'nfs', mount_options: ['nolock']

  config.vm.network "forwarded_port", guest: 80, host: 8088,
      auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.memory = 2048
    vb.cpus = 1
  end

  config.vm.provision "shell", inline: "yum -y install git"
  
  config.vm.provision "ansible_local" do |ansible|
    ansible.galaxy_role_file = 'ansible/requirements.yml'
    ansible.playbook = 'ansible/development-playbook.yml'
    ansible.inventory_path = 'ansible/development.ini'
    ansible.limit = 'all'
    # ansible.verbose = 'vvvv'
  end
end
