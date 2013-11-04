# == Define: sudo
#
# Allow restricted root access for specified users. The name of the defined
# type must consist of only letters, numbers and underscores. If the name
# has incorrect characters the defined type will fail.
#
# === Parameters
#
# [*ensure*]
#   Controls the existence of the sudoers entry. Set this attribute to
#   present to ensure the sudoers entry exists. Set it to absent to
#   delete any computer records with this name Valid values are present,
#   absent.
#
# [*users*]
#   Array of users that are allowed to execute the command(s).
#
# [*cmnds*]
#   List of commands that the user can run.
#
# [*runas*]
#   The user that the command may be run as.
#
# [*cmnds*]
#   The commands which the user is allowed to run.
#
# [*tags*]
#
# === Examples
#
# sudo::sudoers { 'worlddomination':
#   ensure  => 'present',
#   comment => 'World domination.',
#   users   => ['pinky', 'brain'],
#   runas   => ['root'],
#   cmnds   => ['/bin/bash'],
#   tags    => ['NOPASSWD'],
# }
#
# === Authors
#
# Arnoud de Jonge <arnoud.dejonge@nxs.nl>
#
# === Copyright
#
# Copyright 2013 Nxs Internet B.V.
#
define sudo::sudoers (
  $users,
  $cmnds    = 'ALL',
  $comment  = undef,
  $ensure   = 'present',
  $runas    = ['root'],
  $tags     = [],
  $defaults = [],
) {
  if $name !~ /^[A-Za-z0-9_]+$/ {
    fail 'Name should consist of letters numbers or underscores.'
  }
  if $ensure == 'present' {
    file { "/etc/sudoers.d/$name":
      content => template('sudo/sudoers.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
    }
  }
  else {
    file { "/etc/sudoers.d/$name":
      ensure => 'absent',
    }
  }
}
