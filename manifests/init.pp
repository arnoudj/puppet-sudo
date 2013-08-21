# == Class: sudo
#
# Allow restricted root access for specified users. The sudo class is
# specifically created to be used from an ENC.
#
# === Parameters
#
# [*sudoers*]
#   Hash of sudoers which will be created via sudo::sudoers.
#
# [*manage_sudoersd*]
#   Boolean - should puppet clean /etc/sudoers.d/ of untracked files?
#
# [*sudoers_file*]
#   File that should be installed as /etc/sudoers
#
# === Examples
#
# $sudoers = {
#   'worlddomination' => {
#     ensure  => 'present',
#     comment => 'World domination.',
#     users   => ['pinky', 'brain'],
#     runas   => ['root'],
#     cmnds   => ['/bin/bash'],
#     tags    => ['NOPASSWD'],
#   }
# }
#
# class { 'sudo': sudoers => $sudoers }
#
# === Authors
#
# Arnoud de Jonge <arnoud.dejonge@nxs.nl>
#
# === Copyright
#
# Copyright 2013 Nxs Internet B.V.
#
class sudo (
  $sudoers         = [],
  $manage_sudoersd = false,
  $sudoers_file    = ''
) {

  create_resources('sudo::sudoers', $sudoers)

  package { 'sudo':
    ensure  => latest
  }

  file { '/etc/sudoers.d/':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    purge   => $manage_sudoersd,
    recurse => $manage_sudoersd,
    force   => $manage_sudoersd,
  }

  if $sudoers_file =~ /^puppet:\/\// {
    file { '/etc/sudoers':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
      source  => $sudoers_file,
    }
  }

}
