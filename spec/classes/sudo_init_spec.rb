require 'spec_helper'

describe 'sudo', :type => :class do
  let(:facts) { {:puppetversion => '3.8.5' } }
  $testdata = {
     'world.domination' => {
       'ensure'  => 'present',
       'comment' => 'World domination.',
       'users'   => ['pinky', 'brain'],
       'runas'   => ['root'],
       'cmnds'   => ['/bin/bash'],
       'tags'    => ['NOPASSWD'],
     }
  }

  context 'no params' do
    it { should contain_package('sudo').with_ensure('installed') }
    it { should contain_file('/etc/sudoers.d/').with(
      'purge'   => 'false',
      'recurse' => 'false',
      'force'   => 'false'
    ) }
  end

  context 'no params on freebsd' do
    let(:facts) { {:osfamily => 'FreeBSD' } }
    it { should contain_file('/usr/local/etc/sudoers.d/').with(
      'owner' => 'root',
      'group' => 'wheel'
    ) }
  end

  context 'override os specific parameters' do
    let(:facts) { {:osfamily => 'FreeBSD' } }
    let(:params) { { :os_specific_override => { 'sudoers_directory' => '/tmp/sudoers.d'} } }
    it { should contain_file('/tmp/sudoers.d/').with(
      'owner' => 'root',
      'group' => 'wheel'
    ) }
  end

  context 'create_resources' do
    let(:params) { { :sudoers => $testdata } }

    it { should contain_sudo__sudoers('world.domination') }
  end

  context 'managing sudoers.d' do
    let(:params) { { :manage_sudoersd => true } }

    it { should contain_file('/etc/sudoers.d/').with(
      'purge'   => 'true',
      'recurse' => 'true',
      'force'   => 'true'
    ) }
  end

  context 'installing /etc/sudoers' do
    context 'puppet resource' do
      let(:params) { { :sudoers_file => 'puppet:///somewhere/sudoers_default' } }

      it { should contain_file('/etc/sudoers').with(
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0440',
        'source'  => 'puppet:///somewhere/sudoers_default'
      ) }
    end

    context 'http resource' do
      let(:params) { { :sudoers_file => 'http://example.com/somewhere/sudoers_default' } }

      it { should_not contain_file('/etc/sudoers') }
    end
  end

end
