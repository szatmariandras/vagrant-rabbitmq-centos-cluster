class { 'diamond':
  graphite_host => $graphite_host,
  graphite_port => $graphite_port,
  interval      => 10,
  install_from_pip => true
}

diamond::handler { 'GraphiteHandler':
  options => {
    'host' => $graphite_host,
    'post' => $graphite_port,
    'timeout' => 15
  }
}

diamond::collector { 'RabbitMQCollector':
  options => {
    'host' => "${nodename}:15672",
    'cluster' => true,
  },
  sections => {
    '[vhosts]' => {
      '*' => '*'
    }
  }
}

Class['diamond::config']
->
file { 'diamond-updated-rabbitmq-collector':
  path => '/usr/share/diamond/collectors/rabbitmq/rabbitmq.py',
  source => 'puppet:///modules/kinja-rabbitmq/diamond/collectors/rabbitmq-collector.py',
  owner => 'root',
  group => 'root'
}
~>
Class['diamon::service']