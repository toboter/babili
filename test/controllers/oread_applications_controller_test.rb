require 'test_helper'

class OreadApplicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @application = oread_applications(:one)
  end

  test "should get index" do
    get oread_applications_url
    assert_response :success
  end

  test "should get new" do
    get new_oread_application_url
    assert_response :success
  end

  test "should create oread_application" do
    assert_difference('OreadApplication.count') do
      post oread_applications_url, params: { oread_application: { name: @oread_application.name, search_path: @oread_application.search_path } }
    end

    assert_redirected_to oread_application_url(OreadApplication.last)
  end

  test "should show oread_application" do
    get oread_application_url(@oread_application)
    assert_response :success
  end

  test "should get edit" do
    get edit_oread_application_url(@oread_application)
    assert_response :success
  end

  test "should update oread_application" do
    patch oread_application_url(@oread_application), params: { oread_application: { name: @oread_application.name, search_path: @oread_application.search_path } }
    assert_redirected_to oread_application_url(@oread_application)
  end

  test "should destroy oread_application" do
    assert_difference('OreadApplication.count', -1) do
      delete oread_application_url(@oread_application)
    end

    assert_redirected_to oread_applications_url
  end
end
