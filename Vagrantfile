Vagrant.configure(2) do |config|
	config.vm.define "tz-terraform-jenkins" do |node|
		node.vm.box = "ubuntu/bionic64"
    		#node.vm.network "private_network", ip: "192.168.199.9"
    		#node.vm.hostname = "tz-terraform-jenkins"
      		node.vm.provision "shell", path: "scripts/install.sh"
    		node.vm.provider "virtualbox" do |v|
    		  v.memory = 4096
    		  v.cpus = 2
    		end
	end
end
