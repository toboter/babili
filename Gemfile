source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.2'

gem "net-http"
gem "csv"
gem "ostruct"
gem "observer"
gem "benchmark"

gem 'rails', '~> 8.1.0'

gem 'pg', '>= 0.18', '< 2.0'
# PostGIS not used (Locate loc is plain text; no adapter).
# gem 'activerecord-postgis-adapter'
gem "puma", ">= 5.3.1"
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
# ExecJS 2.8.x passes create_additions to JSON.parse; incompatible with json 3.x
gem 'execjs', '>= 2.10'
gem 'sprockets-rails'
# Ruby 3.4: tilt <2.2 freezes/force_encoding breaks font-awesome .css.erb via sassc-rails
gem 'tilt', '>= 2.2'
# Use system Node for ExecJS; coffee-script keeps Sprockets happy with stray .coffee in node_modules.
gem 'coffee-script'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.13'

gem 'mini_magick', '~> 4.9'
gem 'image_processing', '~> 1.2'
gem "streamio-ffmpeg"
gem 'down'
gem 'shrine'
gem 'marcel'
gem 'fastimage'
gem 'exiftool_vendored'
gem 'bootsnap', '>= 1.18.0', require: false
gem 'rack-cors', require: 'rack/cors'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.5'
end

group :test do
  gem 'capybara', '>= 2.15', '< 4.0'
  gem 'selenium-webdriver'
end

# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'devise' #, '= 4.5.0'
gem 'doorkeeper', '~> 5.9.9'
gem 'cancancan'

gem 'bootstrap-sass', '= 3.4.1'
gem "font-awesome-rails"
gem 'simple_form'
gem 'will_paginate-bootstrap'
gem 'cocoon'
gem 'html-pipeline', '~> 2.8', '>= 2.8.4'
gem 'commonmarker' #, '~> 0.17.11'
gem 'github-markup', '~> 2.0', '>= 2.0.1'
gem 'sanitize', '>= 5.2.1' # '~> 4.6', '>= 4.6.6'
gem 'rails-bootstrap-markdown' #
gem 'redcarpet' #

gem 'acts_as_list'
gem 'closure_tree'
gem 'acts_as_dag', git: 'https://github.com/toboter/acts_as_dag.git'
# gem 'acts_as_dag', path: '/home/tschmidt/dev/gem_dev/acts_as_dag'
gem 'acts-as-taggable-on', '~> 13.0'
gem 'sequenced'
# gem "jsonb_accessor", "~> 1.0.0"
# gem 'json_attribute', git: 'https://github.com/jrochkind/json_attribute.git'
gem 'attr_json'

gem 'searchkick', '~> 6.1'
gem "opensearch-ruby", '~> 3.0'

gem 'friendly_id'
gem 'paper_trail', '~> 17.0'
gem 'browser'
gem 'geo_pattern'  # https://github.com/jasonlong/geo_pattern
gem 'inline_svg'   # https://github.com/jamesmartin/inline_svg
gem 'chronic'
# gem "rgeo"
# gem "rgeo-proj4"
gem 'roo'
gem 'activerecord-import'
gem 'xml-to-json', git: 'https://github.com/toboter/ruby-xml-to-json.git'
gem 'hashdiff'
gem 'citeproc-ruby', require: 'citeproc/ruby'
gem 'csl-styles'
gem 'unicode_utils'
gem 'bibtex-ruby', require: 'bibtex'
gem 'namae'
gem 'faraday'
gem 'solid_queue'
gem 'solid_cable'
gem 'sparql-client'
gem 'linkeddata'
gem 'language_list'
gem 'hashie'
gem "recaptcha", require: "recaptcha/rails"
gem 'meta-tags'
gem 'whatlanguage'
