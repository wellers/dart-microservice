Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-18.04"
    config.vm.box_version = "201912.14.0"
    config.vm.network :private_network, ip: "192.168.50.101"
    config.vm.synced_folder ".", "/sv", mount_options:["fmode=777,dmode=777"]
    config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
        v.customize ["modifyvm", :id, "--audio", "none"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
end