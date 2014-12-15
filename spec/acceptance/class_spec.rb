require 'spec_helper_acceptance'

describe 'sudo class' do

  context 'default parameters' do
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'sudo': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe file('/etc/sudoers.d/') do
      it { should be_mode 750 }
      it { should be_owned_by 'root' }
    end
  end
end
