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
# [*manage_package*]
#   Boolean - should puppet manage the sudo package?
#
# [*package_ensure*]
#   Set the ensure variable for the sudo package. Can be 'installed'
#   'latest' or a specific version.
#   Defaults to installed.
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
  $sudoers              = {},
  $manage_sudoersd      = false,
  $manage_package       = true,
  $package_ensure       = 'installed',
  $sudoers_file         = '',
  $os_specific_override = {}
) {

  if ! defined(Class['::sudo::os_specific']) {
    ensure_resource('class', '::sudo::os_specific', $os_specific_override)
  }

  create_resources('sudo::sudoers', $sudoers)

  if $manage_package {
    ensure_packages (['sudo'], {'ensure' => $package_ensure})
  }

  file { $sudo::os_specific::sudoers_directory:
    ensure  => directory,
    owner   => $sudo::os_specific::root_user,
    group   => $sudo::os_specific::root_group,
    mode    => '0750',
    purge   => $manage_sudoersd,
    recurse => $manage_sudoersd,
    force   => $manage_sudoersd,
  }

  if $sudoers_file =~ /^puppet:\/\// {
    file { $sudo::os_specific::sudoers_file_path:
      ensure => file,
      owner  => $sudo::os_specific::root_user,
      group  => $sudo::os_specific::root_group,
      mode   => '0440',
      source => $sudoers_file,
    }
  }

}
