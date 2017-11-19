class CMS::NovelitiesController < ApplicationController
  before_action :set_novelity, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource find_by: :slug
  
  # GET /novelities
  # GET /novelities.json
  def index
    @news = CMS::Novelity.all
    @news_by_years = @news.order(created_at: :desc).group_by { |t| t.created_at.strftime('%Y') }
  end

  # GET /novelities/new
  def new
    @blog = CMS::Novelity.new
  end

  # GET /novelities/1/edit
  def edit
  end

  # POST /novelities
  # POST /novelities.json
  def create
    @novelity = CMS::Novelity.new(novelity_params)
    @novelity.author = current_user

    respond_to do |format|
      if @novelity.save
        format.html { redirect_to cms_novelities_path, notice: "Entry was successfully created." }
        format.json { render :show, status: :created, location: @novelity }
      else
        format.html { render :new }
        format.json { render json: @novelity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /novelities/1
  # PATCH/PUT /novelities/1.json
  def update
    respond_to do |format|
      if @novelity.update(novelity_params)
        format.html { redirect_to cms_novelities_path, notice: "Entry was successfully updated." }
        format.json { render :show, status: :ok, location: @novelity }
      else
        format.html { render :edit }
        format.json { render json: @novelity.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /novelities/1
  # DELETE /novelities/1.json
  def destroy
    @novelity.destroy
    respond_to do |format|
      format.html { redirect_to cms_novelities_path, notice: "Entry was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
   
    # Use callbacks to share common setup or constraints between actions.
    def set_novelity
      @novelity = CMS::Novelity.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def novelity_params
      params.require(:cms_novelity).permit(:author_id, :title, :content)
    end
end
