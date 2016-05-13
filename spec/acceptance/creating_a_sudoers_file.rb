require 'spec_helper_acceptance'

describe 'sudo::sudoers' do

  context 'creating a sudoers file' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      group { 'janedoe':
        ensure => present;
      }
      ->
      user { 'janedoe' :
        gid => 'janedoe',
        home => '/home/janedoe',
        shell => '/bin/sh',
        managehome => true,
        membership => minimum,
      }
      ->
      class {'::sudo':}
      ->
      sudo::sudoers { 'Jane_Hello_World_Sudo':
        ensure  => 'present',
        comment => 'Allow Jane to Sudo Hello World',
        users   => ['janedoe'],
        runas   => ['root'],
        tags    => ['NOPASSWD'],
        cmnds   => ['/bin/echo Hello World'],
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe command("su - janedoe -c 'sudo echo Hello World'") do
      its(:stdout) { should match /Hello World/ }
    end

    describe command("su - janedoe -c 'sudo echo I cant do this'") do
      its(:stderr) { should match /no tty present and no askpass program specified/ }
    end
  end
end
