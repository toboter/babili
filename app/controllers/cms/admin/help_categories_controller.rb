class CMS::Admin::HelpCategoriesController < ApplicationController
  before_action :set_cms_help_category, only: [:edit, :update, :destroy, :move]
  before_action :authenticate_user!
  load_and_authorize_resource param_method: :cms_help_category_params, class: "CMS::HelpCategory", find_by: :slug
  layout "admin"
  
  # GET /cms/help_categories
  # GET /cms/help_categories.json
  def index
    @cms_help_categories = CMS::HelpCategory.order(position: :asc)
  end

  # GET /cms/help_categories/new
  def new
    @cms_help_category = CMS::HelpCategory.new
  end

  # GET /cms/help_categories/1/edit
  def edit
  end

  # POST /cms/help_categories
  # POST /cms/help_categories.json
  def create
    @cms_help_category = CMS::HelpCategory.new(cms_help_category_params)

    respond_to do |format|
      if @cms_help_category.save
        format.html { redirect_to cms_admin_help_categories_url, notice: 'Help category was successfully created.' }
        format.json { render :show, status: :created, location: @cms_help_category }
      else
        format.html { render :new }
        format.json { render json: @cms_help_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cms/help_categories/1
  # PATCH/PUT /cms/help_categories/1.json
  def update
    respond_to do |format|
      if @cms_help_category.update(cms_help_category_params)
        format.html { redirect_to cms_admin_help_categories_url, notice: 'Help category was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_help_category }
      else
        format.html { render :edit }
        format.json { render json: @cms_help_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def move
    if ["move_lower", "move_higher", "move_to_top", "move_to_bottom", "insert"].include?(params[:method])
      respond_to do |format|
        if params[:method] == 'insert' && @cms_help_category.position.nil?
          pos = CMS::HelpCategory.where.not(position: nil).order('position').last.try(:position) || 0
          if @cms_help_category.insert_at(pos+1)
            format.html { redirect_to cms_admin_help_categories_url, notice: "#{@type} was successfully inserted to list." }
          else
            format.html { render :index }
          end
        else 
          if @cms_help_category.send(params[:method])
            format.html { redirect_to cms_admin_help_categories_url, notice: "Position was successfully updated." }
          else
            format.html { render :index }
          end
        end
      end
    end
  end

  # DELETE /cms/help_categories/1
  # DELETE /cms/help_categories/1.json
  def destroy
    @cms_help_category.destroy
    respond_to do |format|
      format.html { redirect_to cms_admin_help_categories_url, notice: 'Help category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_help_category
      @cms_help_category = CMS::HelpCategory.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_help_category_params
      params.require(:cms_help_category).permit(:name, :position)
    end
end
