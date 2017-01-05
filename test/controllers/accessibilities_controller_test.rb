require 'test_helper'

class AccessibilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get accessibilities_new_url
    assert_response :success
  end

  test "should get edit" do
    get accessibilities_edit_url
    assert_response :success
  end

end
