source "http://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.6.1'
  gem "puppet-lint"
  gem "rspec", "~> 3.1.0"
  gem "rspec-puppet"
  gem "puppet-syntax"
  gem "puppetlabs_spec_helper"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
  gem 'listen', '<= 3.0.6', :require => false
end

group :system_tests do
  gem 'beaker-rspec', :require => false
  gem 'serverspec', :require => false
  gem 'signet', git: "https://github.com/google/signet.git"
  gem 'specinfra'
end
