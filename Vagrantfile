# -*- mode: ruby -*-
# vi: set ft=ruby :

# we are setting this here because we want the master node to come up first 
# if we don't put this vagrant will try to bring up all the machines in parrallel
ENV['VAGRANT_NO_PARALLEL'] = 'yes'


Vagrant.configure("2") do |config|
  #this is a common bootstrap we want to apply to both the worker and master node 
  config.vm.provision "shell", path: "bootstrap.sh"
   
  # Kubernetes Master Server
  config.vm.define "kmaster" do |kmaster|
    kmaster.vm.box = "generic/ubuntu2004"
    kmaster.vm.hostname = "kmaster"
    # this can be changed to your wifi bridge adapter 
    kmaster.vm.network "public_network", ip: "172.20.10.15", bridge: "Intel(R) Dual Band Wireless-AC 7265"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "kmaster"
      v.memory = 5000
      v.cpus = 2
    end
    kmaster.vm.provision "shell", path: "bootstrap_kmaster.sh"
  end

  NodeCount = 1
  # this is a loop that will create two worker nodes 

  # Kubernetes Worker Nodes 
  (1..NodeCount).each do |i|
    config.vm.define "kworker#{i}" do |workernode|
      workernode.vm.box = "generic/ubuntu2004"
      workernode.vm.hostname = "kworker#{i}"
      workernode.vm.network "public_network", ip: "172.20.10.16", bridge: "Intel(R) Dual Band Wireless-AC 7265"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "kworker#{i}"
        v.memory = 3000
        v.cpus = 1
      end
      workernode.vm.provision "shell", path: "bootstrap_kworker.sh"
    end

  end
 
end
