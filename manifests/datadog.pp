if $datadog_enabled == 'true' {
  class { "datadog_agent":
    api_key                   => $datadog_api_key,
    collect_ec2_tags          => true,
    collect_instance_metadata => true
  }->
  class { 'datadog_agent::integrations::rabbitmq':
    url => 'http://localhost:15672/api/',
    username => guest,
    password => guest
  }
}