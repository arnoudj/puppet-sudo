class sudo::os_specific(
    $root_user         = $::osfamily ? {
        default  => 'root'
    },
    $root_group        = $::osfamily ? {
        'FreeBSD' => 'wheel',
        default  => 'root'
    },
    $sudoers_directory = $::osfamily ? {
        'FreeBSD' => '/usr/local/etc/sudoers.d',
        default  => '/etc/sudoers.d'
    },
    $sudoers_file_path = $::osfamily ? {
        'FreeBSD' => '/usr/local/etc/sudoers',
        default  => '/etc/sudoers'
    },
    $visudo_path       = $::osfamily ? {
        'FreeBSD' => '/usr/local/sbin/visudo',
        default  => '/usr/sbin/visudo'
    },
) { }
