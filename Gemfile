# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'jbuilder', '~> 2.7'
gem 'puma', '~> 4.1'
gem 'rails', '~> 6.0.1'
gem 'sass-rails', '>= 6'
gem 'sqlite3', '~> 1.4'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'mysql2'

gem 'rtesseract'

gem 'parslet'

group :development, :test do
  gem 'rspec-rails'
  gem 'vcr'
  gem 'webmock', require: nil
end

group :development do
  gem 'rubocop'
  gem 'web-console', '>= 3.3.0'
end
