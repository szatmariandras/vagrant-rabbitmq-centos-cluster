
class { 'kinja-rabbitmq::hostname':
  hostname => $nodename
}

class { 'firewall':
  ensure => 'stopped'
}

import 'rabbitmq.pp'

import 'datadog.pp'

import 'diamond.pp'

import 'graphite.pp'