class chan_dongle {
  $automake = $operatingsystem ? {
    default => 'automake'
  }

  package { "$automake":
    ensure => 'present',
    alias => 'automake'
  }

  vcsrepo { '/usr/local/src/chan-dongle':
    ensure    => latest,
    provider  => 'git',
    source    => 'https://github.com/jstasiak/asterisk-chan-dongle.git',
    before    => Exec['aclocal']
  }

  exec { 'aclocal':
    command => 'aclocal',
    cwd => '/usr/local/src/chan-dongle',
    require => [Package['automake']]
  }
  
  exec { 'autoconf':
    command => "autoconf",
    cwd => "/usr/local/src/chan-dongle",
    require => [Exec['aclocal']]
  }

  exec { 'automake':
    command => 'automake -a',
    cwd => '/usr/local/src/chan-dongle',
    returns => [0,1],
    require => [Exec['autoconf']]
  }

  exec { 'configure':
    command => "/usr/local/src/chan-dongle/configure",
    environment => "DESTDIR=$asterisk::module_path",
    cwd => "/usr/local/src/chan-dongle",
    require => [Exec['automake']]
  }

  exec { 'make':
    command => "make",
    cwd => '/usr/local/src/chan-dongle',
    require => [Exec['configure']]
  }

  exec {'make_install':
    command => "make install",
    cwd => '/usr/local/src/chan-dongle',
    require => [Exec['make']]
  }

  exec {'config':
    command => "cp etc/dongle.conf /etc/asterisk/",
    cwd => "/usr/local/src/chan-dongle",
    require => Exec['make_install']
  }

  #exec {'autoload_dongle':
    #command => "cat 'load => chan_dongle.so' >>/etc/asterisk/modules.conf"
  #  require =>  [ Exec['make_install'], File['/etc/asterisk/modules.conf'] ]
  #}

}
