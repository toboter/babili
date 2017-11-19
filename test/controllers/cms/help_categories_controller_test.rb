require 'test_helper'

class CMS::HelpCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cms_help_category = cms_help_categories(:one)
  end

  test "should get index" do
    get cms_help_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_cms_help_category_url
    assert_response :success
  end

  test "should create cms_help_category" do
    assert_difference('CMS::HelpCategory.count') do
      post cms_help_categories_url, params: { cms_help_category: { name: @cms_help_category.name } }
    end

    assert_redirected_to cms_help_category_url(CMS::HelpCategory.last)
  end

  test "should show cms_help_category" do
    get cms_help_category_url(@cms_help_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_cms_help_category_url(@cms_help_category)
    assert_response :success
  end

  test "should update cms_help_category" do
    patch cms_help_category_url(@cms_help_category), params: { cms_help_category: { name: @cms_help_category.name } }
    assert_redirected_to cms_help_category_url(@cms_help_category)
  end

  test "should destroy cms_help_category" do
    assert_difference('CMS::HelpCategory.count', -1) do
      delete cms_help_category_url(@cms_help_category)
    end

    assert_redirected_to cms_help_categories_url
  end
end
