require 'beaker-rspec'

hosts.each do |host|
  # Install Puppet
  if host['platform'] =~ /freebsd/
    # Beaker tries to install sysutils/puppet
    # It's now been renamed to sysutils/puppet38
    host.install_package('sysutils/puppet38')
  else
    install_puppet
  end
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'sudo')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0] }
    end
  end
end
