# == Class: sudo::validate
#
# Allow checking the sudoers file is valid using visudo
#
# === Examples
#
# include validate
#
# === Authors
#
# Peter Souter <p.morsou@gmail.com>
#
# === Copyright
#
# Copyright 2014
#
class sudo::validate {
  if versioncmp($puppetversion, '3.5') >= 0 {
    File["/etc/sudoers.d/${name}"] { validate_cmd => '/usr/sbin/visudo -c -f %' }
  }
  else {
    # Use puppetlabs-stdlib version here
  }
}