require "test_helper"

# Legacy scaffold from Rails generators; routes/namespaces changed during modernization.
class PersonalAccessTokensControllerTest < ActionDispatch::IntegrationTest
  test "legacy scaffold skipped" do
    skip "Legacy scaffold; not maintained for Rails 8 cutover (see test/controllers/api/)"
  end
end
