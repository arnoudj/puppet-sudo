require 'spec_helper'

describe 'sudo::sudoers', :type => :define do
  let(:title) { 'worlddomination' }

  context 'minimum params' do
    let(:params) { { :users => ['joe'] } }

    it { should contain_file('/etc/sudoers.d/worlddomination') }
  end

  context 'setting all params' do
    let(:params) { {
      :users    => ['pinky', 'brain'],
      :comment  => 'Today we\'re going to take over the world',
      :runas    => ['animaniacs'],
      :cmnds    => ['/bin/bash'],
      :tags     => ['LOG_INPUT', 'LOG_OUTPUT']
    } }

    it { should contain_file('/etc/sudoers.d/worlddomination').with_content(/^# Today\swe\'re\sgoing\sto\stake\sover\sthe\sworld$/) }
    it { should contain_file('/etc/sudoers.d/worlddomination').with_content(/^User_Alias\s*WORLDDOMINATION_USERS\s=\spinky,\sbrain$/) }
    it { should contain_file('/etc/sudoers.d/worlddomination').with_content(/^Runas_Alias\s*WORLDDOMINATION_RUNAS\s=\sanimaniacs$/) }
    it { should contain_file('/etc/sudoers.d/worlddomination').with_content(/^Cmnd_Alias\s*WORLDDOMINATION_CMNDS\s=\s\/bin\/bash$/) }
    it { should contain_file('/etc/sudoers.d/worlddomination').with_content(/^WORLDDOMINATION_USERS\sALL\s=\s\(WORLDDOMINATION_RUNAS\)\sLOG_INPUT:\sLOG_OUTPUT:\sWORLDDOMINATION_CMNDS$/) }
  end

  context 'absent' do
    let(:params) { { :users => 'notneeded', :ensure => 'absent' } }

    it { should contain_file('/etc/sudoers.d/worlddomination').with_ensure('absent')}
  end
end
