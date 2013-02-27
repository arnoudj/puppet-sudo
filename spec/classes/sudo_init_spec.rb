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
  let(:params) { { :sudoers => $testdata } }

  it { should create_class('sudo') }
  it { should contain_sudo__sudoers('worlddomination') }

end
