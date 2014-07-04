Exec { logoutput => true, path => [ "/usr/bin", "/bin", "/sbin", "/usr/sbin"  ], }
File { backup => true, }

package { "build-essential":
  ensure => "installed",
}

package { "vim":
  ensure => "installed",
}

# Configuration settings
#file { '/etc/sysconfig/selinux':
#  content => "SELINUX=disabled\nSELINUXTYPE=targeted",
#}

# Perl Modules
class { 'perl': }
perl::module { 'CGI': }
perl::module { 'LWP': }

## Install mysql
include '::mysql::client'

class {'mysql::server':
  root_password => 'default',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } },
  service_enabled => 'true',
}

class {'mysql::bindings':
  php_enable => 1,
}

file { '/tmp/messages.sql':
  source => "puppet:///modules/asterisk/drcsc-voice/messages.sql",
  ensure => "present",
}

mysql::db { 'drcsc':
  user => 'drcsc',
  password => 'drcsc',
  host => 'localhost',
  grant => 'ALL',
  sql => "/tmp/messages.sql",
  enforce_sql => true
}

# Asterisk 
include asterisk
Class['asterisk'] -> Class['::mysql::server']

# chan_dongle
include chan_dongle
Class['chan_dongle'] -> Class['asterisk']
