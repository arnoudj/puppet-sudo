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
#   Array of hosts that the command(s) can be executed on. Denying hosts using a
#   bang/exclamation point may also be used.
#
# [*runas*]
#   The user that the command may be run as.
#
# [*comment*]
#   Comment to be included in the config file.
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
# [*priority*]
#   Priority of the sudoers entry. Can be a two digit number, or an empty string.
#   Highest priority wins.
#   Defaults to 50.
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
  $ensure   = 'present',
  $users    = undef,
  $group    = undef,
  $hosts    = 'ALL',
  $cmnds    = 'ALL',
  $comment  = undef,
  $runas    = ['root'],
  $tags     = [],
  $defaults = [],
  $priority = 50,
) {

  # Priority, since the order of multiple matching rules matters (the
  # last one found is used), optional and with '_' separator added
  if $priority != '' {
    if "${priority}" !~ /^[[:digit:]]{2}$/ {
      fail "Invalid priority \"${priority}\", should be two digits"
    } else {
      $sane_priority = "${priority}-"
    }
  } else {
    $sane_priority = ''
  }

  # filename as per the manual or aliases as per the sudoer spec must not
  # contain dots.
  # As having dots in a username is legit, let's fudge
  $sane_name = regsubst($name, '\.', '_', 'G')
  $sudoers_user_file = "/etc/sudoers.d/${sane_priority}${sane_name}"

  if $sane_name !~ /^[A-Za-z][A-Za-z0-9_]*$/ {
    fail "Will not create sudoers file \"${sudoers_user_file}\" (for \"${name}\") should consist of letters numbers or underscores."
  }

  if $users != undef and $group != undef {
    fail 'You cannot define both a list of users and a group. Choose one.'
  }
  
  validate_string($group)

  if $ensure == 'present' {
    file { $sudoers_user_file:
      content => template('sudo/sudoers.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0440',
    }
    if versioncmp("${::puppetversion}", '3.5') >= 0 {
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
