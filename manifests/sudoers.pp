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
# [*group*]
#   Group that can run the listed commands. Cannot be combined with users.
#
# [*hosts*]
# Array of hosts that the command(s) can be executed on. Denying hosts using a bang/exclamation point may also be used.
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
#   A command may have zero or more tags associated with it.  There are
#   eight possible tag values, NOPASSWD, PASSWD, NOEXEC, EXEC, SETENV,
#   NOSETENV, LOG_INPUT, NOLOG_INPUT, LOG_OUTPUT and NOLOG_OUTPUT.
#
# [*defaults*]
#   Override some of the compiled in default values for sudo.
#
# === Examples
#
# sudo::sudoers { 'worlddomination':
#   ensure   => 'present',
#   comment  => 'World domination.',
#   users    => ['pinky', 'brain'],
#   runas    => ['root'],
#   cmnds    => ['/bin/bash'],
#   tags     => ['NOPASSWD'],
#   defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
# }
#
# === Authors
#
# Arnoud de Jonge <arnoud@de-jonge.org>
#
# === Copyright
#
# Copyright 2015 Arnoud de Jonge
#
define sudo::sudoers (
  $users    = undef,
  $group    = undef,
  $hosts    = 'ALL',
  $cmnds    = 'ALL',
  $comment  = undef,
  $ensure   = 'present',
  $runas    = ['root'],
  $tags     = [],
  $defaults = [],
  $sudoers_directory = $::sudo::params::sudoers_directory,
  $validate_cmd      = $::sudo::params::visudo_path,
  $root_group        = $::sudo::params::root_group,
) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['sudo']) {
    fail('You must include the sudo base class before using any sudo::sudoers defined resources. Add `include ::sudo:` to your manifest')
  }

  # filename as per the manual or aliases as per the sudoer spec must not
  # contain dots.
  # As having dots in a username is legit, let's fudge
  $sane_name = regsubst($name, '\.', '_', 'G')
  $sudoers_user_file = "${sudoers_directory}/${sane_name}"

  if $sane_name !~ /^[A-Za-z][A-Za-z0-9_]*$/ {
    fail "Will not create sudoers file \"${sudoers_user_file}\" (for user \"${name}\") should consist of letters numbers or underscores."
  }

  if $users != undef and $group != undef {
    fail 'You cannot define both a list of users and a group. Choose one.'
  }

  if $ensure == 'present' {
    file { $sudoers_user_file:
      content => template('sudo/sudoers.erb'),
      owner   => 'root',
      group   => $root_group,
      mode    => '0440',
    }
    if versioncmp($::puppetversion, '3.5') >= 0 {
      File[$sudoers_user_file] { validate_cmd => '/usr/sbin/visudo -c -f %' }
    }
    else {
      validate_cmd(template('sudo/sudoers.erb'), '/usr/sbin/visudo -c -f', 'Visudo failed to validate sudoers content')
    }
  }
  else {
    file { $sudoers_user_file:
      ensure => 'absent',
    }
  }
}
