source 'https://rubygems.org'
# source 'https://gems.ruby-china.org/'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'activerecord-postgis-adapter'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'mini_racer', platforms: :ruby
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# gem 'redis', '~> 3.0'
# gem 'capistrano-rails', group: :development

gem 'mini_magick', '~> 4.8'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'devise'
gem 'doorkeeper', '~> 4.3.0'
gem 'cancancan'

gem 'bootstrap-sass', '~> 3.3.6'
gem 'jquery-turbolinks'
gem "font-awesome-rails"
gem 'simple_form'
gem 'will_paginate-bootstrap'
gem 'cocoon'

gem 'redcarpet'
gem 'acts_as_list'
gem 'closure_tree'
gem 'toastr-rails'
gem 'friendly_id'
gem 'browser'
gem 'shrine'
gem 'image_processing'
gem 'fastimage'
gem 'down'
gem 'rails-bootstrap-markdown'
gem 'geo_pattern'  # https://github.com/jasonlong/geo_pattern
gem 'inline_svg'   # https://github.com/jamesmartin/inline_svg
gem "selectize-rails"
gem 'chronic'
gem 'searchkick'
gem "rgeo"
gem "rgeo-proj4"
gem 'acts-as-taggable-on'
gem 'roo'
gem 'activerecord-import'
gem 'xml-to-json'
gem 'hashdiff'
gem 'sequenced'
gem 'citeproc-ruby'
gem 'csl-styles'
gem 'unicode_utils'
gem 'bibtex-ruby'
gem 'namae'

gem 'rest-client'
gem 'sidekiq'
gem 'sinatra', git: 'https://github.com/sinatra/sinatra.git'
gem 'sparql-client'
gem 'linkeddata'
gem 'acts_as_dag', git: 'https://github.com/toboter/acts_as_dag.git'
# gem 'acts_as_dag', path: '/home/tschmidt/dev/gem_dev/acts_as_dag'
gem 'language_list'
gem 'hashie'
# gem "jsonb_accessor", "~> 1.0.0"
# gem 'json_attribute', git: 'https://github.com/jrochkind/json_attribute.git'
gem 'attr_json'
gem 'trix'
gem "recaptcha", require: "recaptcha/rails"

source 'http://insecure.rails-assets.org' do
  gem 'rails-assets-dropzone'
end