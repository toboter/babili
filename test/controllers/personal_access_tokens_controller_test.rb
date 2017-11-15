require 'test_helper'

class PersonalAccessTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @personal_access_token = personal_access_tokens(:one)
  end

  test "should get index" do
    get personal_access_tokens_url
    assert_response :success
  end

  test "should get new" do
    get new_personal_access_token_url
    assert_response :success
  end

  test "should create personal_access_token" do
    assert_difference('PersonalAccessToken.count') do
      post personal_access_tokens_url, params: { personal_access_token: { access_token: @personal_access_token.access_token, description: @personal_access_token.description, revoked: @personal_access_token.revoked, scope: @personal_access_token.scope } }
    end

    assert_redirected_to personal_access_token_url(PersonalAccessToken.last)
  end

  test "should show personal_access_token" do
    get personal_access_token_url(@personal_access_token)
    assert_response :success
  end

  test "should get edit" do
    get edit_personal_access_token_url(@personal_access_token)
    assert_response :success
  end

  test "should update personal_access_token" do
    patch personal_access_token_url(@personal_access_token), params: { personal_access_token: { access_token: @personal_access_token.access_token, description: @personal_access_token.description, revoked: @personal_access_token.revoked, scope: @personal_access_token.scope } }
    assert_redirected_to personal_access_token_url(@personal_access_token)
  end

  test "should destroy personal_access_token" do
    assert_difference('PersonalAccessToken.count', -1) do
      delete personal_access_token_url(@personal_access_token)
    end

    assert_redirected_to personal_access_tokens_url
  end
end
