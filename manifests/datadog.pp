class { "datadog_agent":
  api_key            => $datadog_api_key,
}->
class { 'datadog_agent::integrations::rabbitmq':
  url => 'http://localhost:15672/api/',
  username => guest,
  password => guest
}