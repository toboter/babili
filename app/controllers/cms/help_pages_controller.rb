class CMS::HelpPagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource find_by: :slug
  
  # GET /help_pages
  # GET /help_pages.json
  def index
    @categories = CMS::HelpCategory.all
  end

  # GET /help_pages/1
  # GET /help_pages/1.json
  def show
  end

  # GET /help_pages/new
  def new
    @page = CMS::HelpPage.new(parent_id: params[:parent_id], category_id: params[:category_id])
  end

  # GET /help_pages/1/edit
  def edit
  end

  # POST /help_pages
  # POST /help_pages.json
  def create
    @page = CMS::HelpPage.new(help_page_params)
    @page.author = current_user

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: "Page was successfully created." }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /help_pages/1
  # PATCH/PUT /help_pages/1.json
  def update

    respond_to do |format|
      if @page.update(help_page_params)
        format.html { redirect_to @page, notice: "Page was successfully updated." }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /help_pages/1
  # DELETE /help_pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to cms_help_pages_path, notice: "Page was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
   
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = CMS::HelpPage.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def help_page_params
      params.require(:cms_help_page).permit(:title, :content, :parent_id, :category_id)
    end
end
