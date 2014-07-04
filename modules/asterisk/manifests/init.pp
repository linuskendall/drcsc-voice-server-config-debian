class asterisk {
  $module_path = $operatingsystem ? {
    debian => "/usr/lib/asterisk/modules",
  }

  $asterisk = $operatingsystem ? {
    default => "asterisk",
  }

  $asterisk_additional = $operatingsystem ? {
    debian => ["asterisk-dev", "asterisk-core-sounds-en", "asterisk-core-sounds-en-g722", "asterisk-core-sounds-en-wav", "asterisk-core-sounds-en-gsm", "asterisk-mp3", "asterisk-modules", "asterisk-mysql", ],
    default => fail("Unrecognized operating system")
  } 

  package { $asterisk:
    ensure => "installed",
    alias => 'asterisk'
  }

  package { $asterisk_additional:
    ensure => "installed",
  }

  group{'asterisk':
    ensure => "present", 
    require => Package['asterisk'], 
  }

  user{'asterisk':
    ensure => "present", 
    gid => "asterisk",
    require => Group['asterisk'], 
  }
  
  file { "/etc/asterisk/extensions.conf":
    ensure => present,
    source => "puppet:///modules/asterisk/drcsc-voice/extensions.conf",
    require => [ Package['asterisk'], User['asterisk'] ],
    owner => 'asterisk',
    group => 'asterisk',
    mode => 640,
    notify => [ Service['asterisk'] ],
  }

  file { "/etc/asterisk/farmers-network.conf":
    ensure => present,
    source => "puppet:///modules/asterisk/drcsc-voice/farmers-network.conf",
    owner => 'asterisk',
    group => 'asterisk',
    mode => 640,
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  file { "/etc/asterisk/modules.conf":
    ensure => present,
    source => "puppet:///modules/asterisk/drcsc-voice/modules.conf",
    require => [ Package['asterisk'], User['asterisk'] ],
    owner => 'asterisk',
    group => 'asterisk',
    mode => 640,
    notify => [ Service['asterisk'] ],
  }

  file { "/etc/asterisk/sip.conf":
    ensure => present,
    source => "puppet:///modules/asterisk/drcsc-voice/sip.conf",
    owner => 'asterisk',
    group => 'asterisk',
    mode => 640,
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  file { "/usr/share/asterisk/agi-bin/":
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    mode => 755,
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  package { "mpg321":
    ensure => "installed",
  }

  package { "sox":
    ensure => "installed",
  }


  file { "/usr/local/bin/googletts-cli.pl":
    ensure => "present",
    mode => 755,
    source => "puppet:///modules/asterisk/drcsc-voice/googletts-cli.pl",
    require => [Package["mpg321"], Package["sox"] ],
  }

  file { "/usr/share/asterisk/agi-bin/googletts.agi":
    ensure => directory,
    source => "puppet:///modules/asterisk/drcsc-voice/googletts.agi",
    owner => 'asterisk',
    group => 'asterisk',
    mode => 755,
    require => [ Package['asterisk'], User['asterisk'], Package["mpg321"], Package["sox"] ],
    notify => [ Service['asterisk'] ],
  }

  service { 'asterisk':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true
  }
}
