class rackspace::cloudbackup (
  $cloudbackup_install      = params_lookup('cloudbackup_install'),
  $rax_username             = params_lookup('rax_username'),
  $rax_api_key              = params_lookup('rax_api_key')
) inherits rackspace::params {
  if $cloudbackup_install == false {
    package { 'driveclient': ensure => absent }
    package { 'cloudbackup-updater': ensure => absent }
    file { "/etc/yum.repos.d/drivesrvrng.repo": ensure  => absent }
    file { "/etc/driveclient/bootstrap.json": ensure  => absent }
  } else {
    yumrepo {'drivesrvr':
      enabled   => 1,
      gpgcheck  => 0,
      baseurl   => 'http://agentrepo.drivesrvr.com/redhat/',
      descr     => 'drivesrvr',
      gpgkey    => 'http://agentrepo.drivesrvr.com/redhat/RPM-GPG-KEY-driveclient'
    }

    package {'driveclient':
      ensure  => present,
      require => Yumrepo['drivesrvr'],
    }

    exec { 'cloudbackup_updater':
      command     => "cloudbackup-updater -v",
      path        => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
      unless      => "/bin/grep IsRegistered /etc/driveclient/bootstrap.json | /bin/grep -q true",
      require     => [ Package[ 'driveclient' ] ]
    }

    exec { 'configure_driveclient':
      command     => "driveclient --configure --username=${rax_username} --apikey=${rax_api_key}",
      path        => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
      unless      => "/bin/grep IsRegistered /etc/driveclient/bootstrap.json | /bin/grep -q true",
      notify      => [ Service["driveclient"] ],
      require     => [
        Package[ 'driveclient' ]
      ]
    }

    service { 'driveclient':
      ensure  => running,
      enable  => true,
      require => [
        Package['driveclient'],
        Exec["configure_driveclient"]
      ]
    }
  }
}
