class CMS::BlogCategoriesController < ApplicationController
  before_action :set_categories
  before_action :get_unpublished

  def all
    @blogs = CMS::BlogPage.order(created_at: :desc)
    render 'cms/blog_pages/index'
  end

  def show
    @category = CMS::BlogCategory.friendly.find(params[:id])
  end

  def unpublished_blogs
    @blogs = @unpublished_blogs.order(created_at: :asc) if @unpublished_blogs.present?
    render 'cms/blog_pages/index'
  end

  private
    def set_categories
      @categories = CMS::BlogCategory.order(name: :asc)
    end

    def get_unpublished
      @unpublished_blogs = current_user.blog_pages.where(published_at: nil) if user_signed_in?
    end
  
end