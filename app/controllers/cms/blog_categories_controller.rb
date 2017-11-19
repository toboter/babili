class CMS::BlogCategoriesController < ApplicationController

  def all
    @blogs = CMS::BlogPage.order(created_at: :desc)
    @categories = CMS::BlogCategory.order(name: :asc)
    render 'cms/blog_pages/index'
  end

  def show
    @category = CMS::BlogCategory.friendly.find(params[:id])
    @categories = CMS::BlogCategory.order(name: :asc)
  end
  
end