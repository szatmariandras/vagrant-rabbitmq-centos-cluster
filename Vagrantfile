# Define the cluster
nodes = [
  { :hostname => 'rabbit1.vagrant.local', :ip => '192.168.0.101'},
  { :hostname => 'rabbit2.vagrant.local', :ip => '192.168.0.102'}
]

Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"

  # add vagrant-cachier
  config.cache.scope = :box

  #Setup hostmanager config to update the host files
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.vm.provision :hostmanager

  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|

      node_config.vm.hostname = node[:hostname]
      node_config.vm.network :private_network, ip: node[:ip]
      
      # configure hostmanager
      node_config.hostmanager.aliases = node[:hostname]
      
      node_config.vm.provision "puppet" do |puppet|
#          puppet.options = "--verbose --debug"
          puppet.module_path = "modules"
          
          puppet.facter = {
            "nodename"      => node[:hostname],
            "cluster_nodes" => 'rabbit1.vagrant.local,rabbit2.vagrant.local'
          }
      end
    end
  end
end