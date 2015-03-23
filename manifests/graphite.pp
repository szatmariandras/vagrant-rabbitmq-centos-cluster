class { 'graphite':
  gr_timezone                 => 'America/New_York',
  gr_line_receiver_port       => 2003,
  gr_pickle_receiver_port     => 2004,
  gr_cache_query_port         => 7002,
  gr_max_updates_per_second   => 10000,
  gr_max_creates_per_minute   => 200,
  gr_web_cors_allow_from_all  => true,
  gr_web_cors_allow_from_host => "*",
  gr_storage_schemas          => [
    {
      name       => 'carbon',
      pattern    => '^carbon\.',
      retentions => '60s:7d'
    },
    {
      name       => 'default',
      pattern    => '.*',
      retentions => '10s:4d,60s:7d'
    }
  ],
  gr_blacklist                => [
    '^.*_squares.*$',
    '^.*std.*$',
    '^.*count_90.*$',
    '^.*sum_90.*$'
  ]
}