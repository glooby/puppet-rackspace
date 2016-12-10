class rackspace::cloudmonitoring (
  $cloudmonitoring_install  = params_lookup('cloudmonitoring_install'),
  $username                 = params_lookup('username'),
  $api_key                  = params_lookup('api_key')
) inherits rackspace::params {
  if $cloudmonitoring_install == false {
    package { 'rackspace-monitoring-agent': ensure => absent }
    file { "/etc/rackspace-monitoring-agent.cfg": ensure  => absent }
    file { "/etc/yum.repos.d/rackspace-cloud-monitoring.repo": ensure  => absent }
  } else {
    yumrepo { 'rackspace-cloud-monitoring':
      descr    => 'Rackspace Monitoring',
      baseurl  => "http://stable.packages.cloudmonitoring.rackspace.com/centos-6-x86_64",
      gpgkey   => "https://monitoring.api.rackspacecloud.com/pki/agent/centos-6.asc",
      enabled  => 1,
      priority => 1,
      gpgcheck  => 1,
    }

    package { 'rackspace-monitoring-agent':
      ensure  => installed,
      require => Yumrepo['rackspace-cloud-monitoring'],
    }

    exec { 'configure_rackspace_monitoring_agent':
      command     => "rackspace-monitoring-agent --setup --username ${username} --apikey ${api_key}",
      path        => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
      unless			=> "cat /etc/rackspace-monitoring-agent.cfg | /bin/grep monitoring_token",
      notify      => [ Service["rackspace-monitoring-agent"] ],
      require     => [
        Package[ 'rackspace-monitoring-agent' ]
      ]
    }

    service { 'rackspace-monitoring-agent':
      ensure  => running,
      enable  => true,
      require => [
      Package['rackspace-monitoring-agent'],
        Exec['configure_rackspace_monitoring_agent'],
      ]
    }
  }
}
