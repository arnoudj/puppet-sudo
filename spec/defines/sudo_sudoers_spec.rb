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
      :tags     => ['LOG_INPUT', 'LOG_OUTPUT'],
      :defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
      } }

    it { should contain_file('/etc/sudoers.d/world_domination').with_content(/^# Today\swe\'re\sgoing\sto\stake\sover\sthe\sworld$/) }
    it { should contain_file('/etc/sudoers.d/world_domination').with_content(/^User_Alias\s*WORLDDOMINATION_USERS\s=\spinky,\sbrain$/) }
    it { should contain_file('/etc/sudoers.d/world_domination').with_content(/^Runas_Alias\s*WORLDDOMINATION_RUNAS\s=\sanimaniacs$/) }
    it { should contain_file('/etc/sudoers.d/world_domination').with_content(/^Cmnd_Alias\s*WORLDDOMINATION_CMNDS\s=\s\/bin\/bash$/) }
    it { should contain_file('/etc/sudoers.d/world_domination').with_content(/^WORLDDOMINATION_USERS\sALL\s=\s\(WORLDDOMINATION_RUNAS\)\sLOG_INPUT:\sLOG_OUTPUT:\sWORLDDOMINATION_CMNDS$/) }
    it { should contain_file('/etc/sudoers.d/world_domination').with_content(/Defaults:WORLDDOMINATION_USERS env_keep \+= "SSH_AUTH_SOCK"/) }

  end

  if (Puppet.version >= '3.5.0')
    context "validating content with puppet #{Puppet.version}" do
      let(:params) { { :users => ['joe'] } }
      let(:facts) {{ :puppetversion => Puppet.version }}

      it { should contain_file('/etc/sudoers.d/world_domination').with_validate_cmd('/usr/sbin/visudo -c -f %') }
    end
  else
    context "validating content with puppet #{Puppet.version}" do
      let(:params) { { :users => ['joe'] } }
      let(:facts) {{ :puppetversion => Puppet.version }}

      it { should contain_file('/etc/sudoers.d/world_domination').with_validate_cmd(nil) }
    end
  end

  context 'absent' do
    let(:params) { { :users => 'notneeded', :ensure => 'absent' } }

    it { should contain_file('/etc/sudoers.d/world_domination').with_ensure('absent')}
  end
end
