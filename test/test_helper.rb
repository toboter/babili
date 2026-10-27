ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Legacy fixture YAMLs are incomplete stubs; create records in tests instead.
  # fixtures :all
end
