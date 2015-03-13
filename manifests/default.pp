
class sethostname($hostname) {
  file { "/etc/sysconfig/network":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "NETWORKING=yes\nHOSTNAME=${hostname}\n"
  }
  exec { "set-hostname":
    command => "/bin/hostname ${hostname}"
  }
  exec { "restart-networking":
  	command => "/etc/init.d/network restart"
  }
}

class { 'sethostname': 
  hostname => $nodename
}

class { 'erlang': epel_enable => true } ->

class { 'rabbitmq':
  port                     => '5672',
  version                  => '3.5.0-1',
  admin_enable		         => true,
  config_cluster           => true,
  cluster_nodes            => split($cluster_nodes, ','),
  cluster_node_type        => 'disc', 
  erlang_cookie            => 'dfaksdva9sfjlkamdeslofaszpkvawnj3rnbfkvd', 
  wipe_db_on_cookie_change => true,
  environment_variables    => {
    'NODENAME' => "rabbit@${nodename}",
    'RABBITMQ_USE_LONGNAME' => true
  },
  config_variables	       => {
  	loopback_users => "[]",
    disk_free_limit => "{mem_relative, 0.1}",
    vm_memory_high_watermark => 0.4
  }
}

class { 'firewall': 
  ensure => 'stopped'  
}