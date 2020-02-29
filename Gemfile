# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.0.2'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

gem 'kaminari'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'pg'
gem 'pg_search'

gem 'rtesseract'

gem 'parslet'

gem 'twitter'

gem 'sucker_punch'

gem 'geocoder'

gem 'lograge'

group :production do
  gem 'rufus-scheduler'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock', require: nil
end

group :development do
  gem 'rubocop'
  gem 'web-console', '>= 3.3.0'
end
