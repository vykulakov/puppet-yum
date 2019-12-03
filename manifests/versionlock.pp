# Define: yum::versionlock
#
# This definition locks package from updates.
#
# NOTE: The resource title is passed directly to the yum versionlock command so check the man pages of the yum
#   versionlock plugin to explain which format may be used here.
#
# Parameters:
#   [*ensure*] - specifies if versionlock should be present, absent or exclude
#
# Actions:
#
# Requires:
#   RPM based system, Yum versionlock plugin
#
# Sample usage:
#   yum::versionlock { '0:bash-4.1.2-9.el6_2.*':
#     ensure  => 'present',
#   }
#
define yum::versionlock (
  Enum['present', 'absent', 'exclude'] $ensure = 'present',
) {
  contain yum::plugin::versionlock

  case $ensure {
    'present', default: {
      $cmd = 'add'
    }
    'exclude': {
      $cmd = 'exclude'
    }
    'absent': {
      $cmd = 'delete'
    }
  }
  exec { "yum-versionlock-${name}":
    command => "/usr/bin/yum versionlock ${cmd} ${name}",
  }
}
