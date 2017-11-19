require 'test_helper'

class CMS::BlogCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cms_blog_category = cms_blog_categories(:one)
  end

  test "should get index" do
    get cms_blog_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_cms_blog_category_url
    assert_response :success
  end

  test "should create cms_blog_category" do
    assert_difference('CMS::BlogCategory.count') do
      post cms_blog_categories_url, params: { cms_blog_category: { name: @cms_blog_category.name } }
    end

    assert_redirected_to cms_blog_category_url(CMS::BlogCategory.last)
  end

  test "should show cms_blog_category" do
    get cms_blog_category_url(@cms_blog_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_cms_blog_category_url(@cms_blog_category)
    assert_response :success
  end

  test "should update cms_blog_category" do
    patch cms_blog_category_url(@cms_blog_category), params: { cms_blog_category: { name: @cms_blog_category.name } }
    assert_redirected_to cms_blog_category_url(@cms_blog_category)
  end

  test "should destroy cms_blog_category" do
    assert_difference('CMS::BlogCategory.count', -1) do
      delete cms_blog_category_url(@cms_blog_category)
    end

    assert_redirected_to cms_blog_categories_url
  end
end
