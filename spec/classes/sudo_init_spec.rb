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

  context 'create_resources' do
    let(:params) { { :sudoers => $testdata } }

    it { should create_class('sudo') }
    it { should contain_sudo__sudoers('worlddomination') }

    it { should contain_file('/etc/sudoers.d/').with(
      'purge'   => 'false',
      'recurse' => 'false',
      'force'   => 'false'
    ) }
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
