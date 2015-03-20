
class { 'kinja-rabbitmq::hostname':
  hostname => $nodename
}

class { 'firewall':
  ensure => 'stopped'
}

import 'rabbitmq.pp'

if ($datadog_enabled == "true") {
  import 'datadog.pp'
}

if ($monitor_to_graphite == "true") {
  import 'diamond.pp'
}

if ($install_graphite == "true") {
  import 'graphite.pp'
}
