source "https://rubygems.org"

gem 'spree', github: 'spree/spree', branch: '2-3-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-3-stable'

group :test, :development do
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'spree_wombat', github: 'spree/spree_wombat', branch: "2-3-stable"

  gem 'spree_digital', '>= 2.6.8', git: 'git@github.com:deseretbook/spree_digital.git', branch: '2-3-stable'
  gem 'almery', '>= 1.1.23', git: 'git@github.com:deseretbook/almery.git'
  gem 'yoke', git: 'git@github.com:deseretbook/yoke.git'
end

gemspec
