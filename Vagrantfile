# Define the cluster

config = {
    :datadog => {
        :enabled => true,
        :apikey => ''
    },
    :graphite_host => 'rabbit1.vagrant.local',
    :graphite_port => 2003,
    :cluster_nodes => 'rabbit1.vagrant.local,rabbit2.vagrant.local',
    :nodes => [
        {
            :hostname => 'rabbit1.vagrant.local',
            :ip => '192.168.0.101',
            :monitor_to_graphite => true,
            :install_graphite => true
        },
        {
            :hostname => 'rabbit2.vagrant.local',
            :ip => '192.168.0.102',
            :monitor_to_graphite => true
        }
    ]
}

if File.exists? ('config.local')
    external = File.read 'config.local'
    eval external
end

Vagrant.configure("2") do |provisioner|
  provisioner.vm.box = "puppetlabs/centos-6.6-64-puppet"

  # add vagrant-cachier
  provisioner.cache.scope = :box

  #Setup hostmanager config to update the host files
  provisioner.hostmanager.enabled = true
  provisioner.hostmanager.manage_host = true
  provisioner.hostmanager.ignore_private_ip = false
  provisioner.hostmanager.include_offline = true
  provisioner.vm.provision :hostmanager

  config[:nodes].each do |node|
    provisioner.vm.define node[:hostname] do |node_config|

      node_config.vm.hostname = node[:hostname]
      node_config.vm.network :private_network, ip: node[:ip]
      
      # configure hostmanager
      node_config.hostmanager.aliases = node[:hostname]
      
      node_config.vm.provision "puppet" do |puppet|
          puppet.options = "--verbose --debug"
          puppet.module_path = "modules"
          
          puppet.facter = {
            "nodename"            => node[:hostname],
            "cluster_nodes"       => config[:cluster_nodes],
            "graphite_host"       => config[:graphite_host],
            "graphite_port"       => config[:graphite_port],
            "install_graphite"    => node[:install_graphite],
            "monitor_to_graphite" => node[:monitor_to_graphite],
            "datadog_enabled"     => config[:datadog][:enabled],
            "datadog_api_key"     => config[:datadog][:apikey],
          }
      end
    end
  end
end