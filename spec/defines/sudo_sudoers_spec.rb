require 'spec_helper'

describe 'sudo::sudoers', :type => :define do
  let(:facts) { {:puppetversion => '3.8.5', :osfamily => 'Debian' } }
  let(:title) { 'world.domination' }

  context 'minimum params' do
    let(:params) { { :users => ['joe'] } }

    it { should contain_file('/etc/sudoers.d/50-world_domination') }
  end

  context 'setting sudo for a user' do
    let(:params) { {
      :users    => ['pinky', 'brain'],
      :comment  => 'Today we\'re going to take over the world',
      :runas    => ['animaniacs'],
      :cmnds    => ['/bin/bash'],
      :tags     => ['LOG_INPUT', 'LOG_OUTPUT'],
      :defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
    } }

    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^# Today\swe\'re\sgoing\sto\stake\sover\sthe\sworld$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^User_Alias\s*WORLD_DOMINATION_USERS\s=\spinky,\sbrain$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^Runas_Alias\s*WORLD_DOMINATION_RUNAS\s=\sanimaniacs$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^Cmnd_Alias\s*WORLD_DOMINATION_CMNDS\s=\s\/bin\/bash$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^WORLD_DOMINATION_USERS\sWORLD_DOMINATION_HOSTS\s=\s\(WORLD_DOMINATION_RUNAS\)\sLOG_INPUT:\sLOG_OUTPUT:\sWORLD_DOMINATION_CMNDS$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/Defaults!WORLD_DOMINATION_CMNDS env_keep \+= "SSH_AUTH_SOCK"/) }
  end

  context 'setting sudo for a group' do
    let(:params) { {
      :group    => 'lab',
      :comment  => 'Today we\'re going to take over the world',
      :runas    => ['animaniacs'],
      :cmnds    => ['/bin/bash'],
      :tags     => ['LOG_INPUT', 'LOG_OUTPUT'],
      :defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
    } }

    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^# Today\swe\'re\sgoing\sto\stake\sover\sthe\sworld$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^Runas_Alias\s*WORLD_DOMINATION_RUNAS\s=\sanimaniacs$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^Cmnd_Alias\s*WORLD_DOMINATION_CMNDS\s=\s\/bin\/bash$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/%lab\sWORLD_DOMINATION_HOSTS\s=\s\(WORLD_DOMINATION_RUNAS\)\sLOG_INPUT:\sLOG_OUTPUT:\sWORLD_DOMINATION_CMNDS$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/Defaults!WORLD_DOMINATION_CMNDS env_keep \+= "SSH_AUTH_SOCK"/) }
  end

  context 'change priority' do
    let(:params) { {
      :group    => 'lab',
      :comment  => 'Today we\'re going to take over the world',
      :runas    => ['animaniacs'],
      :cmnds    => ['/bin/bash'],
      :tags     => ['LOG_INPUT', 'LOG_OUTPUT'],
      :defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ],
      :priority => 99
    } }

    it { should contain_file('/etc/sudoers.d/99-world_domination') }
  end

  context 'using strings instead of arrays' do
    let(:params) { {
      :users    => 'riton',
      :runas    => 'root',
      :cmnds    => '/bin/bash',
      :tags     => 'NOPASSWD',
      :defaults => 'env_keep += "KRB5CCNAME"'
    } }

    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^User_Alias\s*WORLD_DOMINATION_USERS\s=\sriton$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^Runas_Alias\s*WORLD_DOMINATION_RUNAS\s=\sroot$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^Cmnd_Alias\s*WORLD_DOMINATION_CMNDS\s=\s\/bin\/bash$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/^WORLD_DOMINATION_USERS\sWORLD_DOMINATION_HOSTS\s=\s\(WORLD_DOMINATION_RUNAS\)\sNOPASSWD:\sWORLD_DOMINATION_CMNDS$/) }
    it { should contain_file('/etc/sudoers.d/50-world_domination').with_content(/Defaults!WORLD_DOMINATION_CMNDS env_keep \+= "KRB5CCNAME"/) }
  end

  context 'giving an incorrect type for a group' do
    let(:params) { {
      :group    => ['lab'],
      :comment  => 'Today we\'re going to take over the world',
      :runas    => ['animaniacs'],
      :cmnds    => ['/bin/bash'],
      :tags     => ['LOG_INPUT', 'LOG_OUTPUT'],
      :defaults => [ 'env_keep += "SSH_AUTH_SOCK"' ]
    } }

    it 'should fail' do
      expect { should contain_file('/etc/sudoers.d/50-world_domination') }.to raise_error(Puppet::Error, /\["lab"\] is not a string.  It looks to be a Array/)
    end
  end

  if (Puppet.version >= '3.5.0')
    context "validating content with puppet #{Puppet.version}" do
      let(:params) { { :users => ['joe'] } }
      let(:facts) {{ :puppetversion => Puppet.version, :osfamily => 'Debian' }}

      it { should contain_file('/etc/sudoers.d/50-world_domination').with_validate_cmd('/usr/sbin/visudo -c -f %') }
    end
  else
    context "validating content with puppet #{Puppet.version}" do
      let(:params) { { :users => ['joe'] } }
      let(:facts) {{ :puppetversion => Puppet.version, :osfamily => 'Debian' }}

      it { should contain_file('/etc/sudoers.d/50-world_domination').with_validate_cmd(nil) }
    end
  end

  context 'absent' do
    let(:params) { { :users => 'notneeded', :ensure => 'absent' } }

    it { should contain_file('/etc/sudoers.d/50-world_domination').with_ensure('absent')}
  end
end
