class CMS::BlogCategoriesController < ApplicationController
  before_action :set_categories
  before_action :get_unpublished

  def all
    @blogs = CMS::BlogPage.order(created_at: :desc)
    authorize! :read, @blogs
    render 'cms/blog_pages/index'
  end

  def show
    @category = CMS::BlogCategory.friendly.find(params[:id])
    @category_blogs = @category.blog_pages
    authorize! :read, @category_blogs
  end

  def unpublished_blogs
    @blogs = @unpublished_blogs.order(created_at: :asc) if @unpublished_blogs.present?
    authorize! :read, @blogs
    render 'cms/blog_pages/index'
  end

  private
    def set_categories
      @categories = CMS::BlogCategory.order(name: :asc)
    end

    def get_unpublished
      @unpublished_blogs = current_person.blog_pages.unpublished if user_signed_in?
    end
  
end