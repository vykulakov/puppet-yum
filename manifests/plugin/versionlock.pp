# Class: yum::plugin::versionlock
#
# This class installs versionlock plugin
#
# Parameters:
#   [*ensure*] - specifies if versionlock should be present or absent
#   [*clean*] - specifies if yum clean all should be called after edits. Defaults false.
#   [*remove_locks*] - specifies if versionlock should remove all existing locks. Defaults true.
#
# Actions:
#
# Requires:
#
# Sample usage:
#   include yum::plugin::versionlock
#
class yum::plugin::versionlock (
  Enum['present', 'absent'] $ensure       = 'present',
  String                    $path         = '/etc/yum/pluginconf.d/versionlock.list',
  Boolean                   $clean        = false,
  Boolean                   $remove_locks = true,
) {

  yum::plugin { 'versionlock':
    ensure => $ensure,
  }

  include yum::clean
  $_clean_notify = $clean ? {
    true  => Exec['yum_clean_all'],
    false => undef,
  }

  # Just implement the old behaviour by removing all existing version locks in the very beginning.
  if $remove_locks {
    exec { 'yum-versionlock-clear':
      command => '/usr/bin/yum versionlock clear',
      notify  => $_clean_notify,
    }
  }
}
