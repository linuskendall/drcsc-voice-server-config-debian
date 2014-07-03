Exec { logoutput => true, path => [ "/usr/bin", "/bin", "/sbin", "/usr/sbin"  ] }

# Configuration settings
file { '/etc/sysconfig/selinux':
  content => "SELINUX=disabled\nSELINUXTYPE=targeted",
}

# Perl Modules
class { 'perl': }
perl::module { 'cgi': }
perl::module { 'lwp': }

## Install mysql
include '::mysql::client'

class {'mysql::server':
  root_password    => 'default',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } },
  service_enabled   => 'true',
}

class {'mysql::bindings':
  php_enable => 1,
}

# Asterisk 
#include asterisk

# chan_dongle
#include chan_dongle
#Class['chan_dongle'] -> Class['asterisk']
