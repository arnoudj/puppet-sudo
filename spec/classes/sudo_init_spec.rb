require 'spec_helper'

describe 'sudo', :type => :class do
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
    it { should contain_package('sudo').with_ensure('latest') }
    it { should contain_file('/etc/sudoers.d/').with(
      'purge'   => 'false',
      'recurse' => 'false',
      'force'   => 'false'
    ) }
  end

  context 'create_resources' do
    let(:params) { { :sudoers => $testdata } }

    it { should contain_sudo__sudoers('worlddomination') }
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
