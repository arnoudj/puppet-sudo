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
# Arnoud de Jonge <arnoud@de-jonge.org>
#
# === Copyright
#
# Copyright 2015 Arnoud de Jonge
#
class sudo (
  $sudoers           = {},
  $manage_sudoersd   = false,
  $manage_package    = true,
  $sudoers_file      = '',
  $root_group        = $::sudo::params::root_group,
  $sudoers_directory = $::sudo::params::sudoers_directory,
  $sudoers_file_path = $::sudo::params::sudoers_file_path,
) inherits sudo::params {

  create_resources('sudo::sudoers', $sudoers)

  if $manage_package {
    package { 'sudo':
      ensure  => latest
    }
  }

  file { $sudoers_directory:
    ensure  => directory,
    owner   => 'root',
    group   => $root_group,
    mode    => '0750',
    purge   => $manage_sudoersd,
    recurse => $manage_sudoersd,
    force   => $manage_sudoersd,
  }

  if $sudoers_file =~ /^puppet:\/\// {
    file { $sudoers_file_path:
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0440',
      source => $sudoers_file,
    }
  }

}
