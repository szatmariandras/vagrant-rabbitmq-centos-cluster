class kinja-rabbitmq::hostname($hostname) {
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