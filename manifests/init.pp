class rackspace (
  $cloudbackup_install      = params_lookup('cloudbackup_install'),
  $cloudmonitoring_install  = params_lookup('cloudmonitoring_install'),
  $username                 = params_lookup('username'),
  $api_key                  = params_lookup('api_key')
) inherits rackspace::params {

  if ! $username {
    fail('You must specify a username.')
  }

  if ! $api_key {
    fail('You must specify a api key.')
  }

  class { 'rackspace::cloudbackup':
    cloudbackup_install => $cloudbackup_install,
    username            => $username,
    api_key             => $api_key
  }

  class { 'rackspace::cloudmonitoring':
    cloudmonitoring_install => $cloudmonitoring_install,
    username                => $username,
    api_key                 => $api_key
  }
}
