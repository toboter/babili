class CMS::Admin::BlogCategoriesController < ApplicationController
  before_action :set_cms_blog_category, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :cms_blog_category_params, class: "CMS::BlogCategory", find_by: :slug
  layout "admin"

  # GET /cms/blog_categories
  # GET /cms/blog_categories.json
  def index
    @cms_blog_categories = CMS::BlogCategory.all
  end

  # GET /cms/blog_categories/new
  def new
    @cms_blog_category = CMS::BlogCategory.new
  end

  # GET /cms/blog_categories/1/edit
  def edit
  end

  # POST /cms/blog_categories
  # POST /cms/blog_categories.json
  def create
    @cms_blog_category = CMS::BlogCategory.new(cms_blog_category_params)

    respond_to do |format|
      if @cms_blog_category.save
        format.html { redirect_to cms_admin_blog_categories_url, notice: 'Blog category was successfully created.' }
        format.json { render :show, status: :created, location: @cms_blog_category }
      else
        format.html { render :new }
        format.json { render json: @cms_blog_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/blog_categories/1
  # PATCH/PUT /cms/blog_categories/1.json
  def update
    respond_to do |format|
      if @cms_blog_category.update(cms_blog_category_params)
        format.html { redirect_to cms_admin_blog_categories_url, notice: 'Blog category was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_blog_category }
      else
        format.html { render :edit }
        format.json { render json: @cms_blog_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cms/blog_categories/1
  # DELETE /cms/blog_categories/1.json
  def destroy
    @cms_blog_category.destroy
    respond_to do |format|
      format.html { redirect_to cms_admin_blog_categories_url, notice: 'Blog category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_blog_category
      @cms_blog_category = CMS::BlogCategory.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_blog_category_params
      params.require(:cms_blog_category).permit(:name)
    end
end
