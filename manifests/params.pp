# == Class: sudo::params
#
#
class sudo::params
{

  case $::osfamily {
    'FreeBSD': {
      $root_group        = 'wheel'
      $sudoers_directory = '/usr/local/etc/sudoers.d'
      $sudoers_file_path = '/usr/local/etc/sudoers'
      $validate_cmd      = '/usr/local/sbin/visudo -c -f %'
    }
    default: {
      $root_group        = 'root'
      $sudoers_directory = '/etc/sudoers.d'
      $sudoers_file_path = '/etc/sudoers'
      $validate_cmd      = '/usr/sbin/visudo -c -f %'
    }
  }


}
