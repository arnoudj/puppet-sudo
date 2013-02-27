require 'spec_helper'

describe 'sudo', :type => :class do
  $testdata = {
     'worlddomination' => {
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

end
