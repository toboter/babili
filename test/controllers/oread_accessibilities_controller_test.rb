require 'test_helper'

class OreadAccessibilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get oread_accessibilities_new_url
    assert_response :success
  end

  test "should get edit" do
    get oread_accessibilities_edit_url
    assert_response :success
  end

end
