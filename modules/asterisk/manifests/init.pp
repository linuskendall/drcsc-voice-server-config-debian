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
    notify => [ Service['asterisk'] ],
  }

  file { "/etc/asterisk/farmers-network.conf":
    ensure => present,
    source => "puppet:///modules/asterisk/drcsc-voice/farmers-network.conf",
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  file { "/etc/asterisk/sip.conf":
    ensure => present,
    source => "puppet:///modules/asterisk/drcsc-voice/sip.conf",
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  file { "/var/lib/asterisk/agi-bin/":
    ensure => directory,
    owner => 'asterisk',
    group => 'asterisk',
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  file { "/var/lib/asterisk/agi-bin/googletts.agi":
    ensure => directory,
    source => "puppet:///modules/asterisk/drcsc-voice/googletts.agi",
    owner => 'asterisk',
    group => 'asterisk',
    require => [ Package['asterisk'], User['asterisk'] ],
    notify => [ Service['asterisk'] ],
  }

  service { 'asterisk':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true
  }
}
