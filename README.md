# sudo

Allow restricted root access for specified users. The name of the defined
type must consist of only letters, numbers and underscores and should be
unique. If the name has incorrect characters the defined type will fail.
Sudoers entries realised with the `sudo::sudoers` defined type  will be saved in
`"/etc/sudoers.d/[typename]"`.

## Parameters

### ensure

  Controls the existence of the sudoers entry. Set this attribute to
  present to ensure the sudoers entry exists. Set it to absent to
  delete any computer records with this name Valid values are present,
  absent.

### users

Array of users that are allowed to execute the command(s).

### cmnds

List of commands that the user can run.

### runas

The user that the command may be run as.

### cmnds

The commands which the user is allowed to run.

### tags

There are eight possible tag values, `NOPASSWD`, `PASSWD`, `NOEXEC`, `EXEC`,
`SETENV`, `NOSETENV`, `LOG_INPUT, NOLOG_INPUT`, `LOG_OUTPUT` and
`NOLOG_OUTPUT`.

## Example

    sudo::sudoers { 'worlddomination':
      ensure  => 'present',
      comment => 'World domination.',
      users   => ['pinky', 'brain'],
      runas   => 'root',
      cmnds   => 'ALL',
      tags    => 'NOPASSWD',
    }
