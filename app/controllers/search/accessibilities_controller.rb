module Search
class Search::AccessibilitiesController < ApplicationController
  before_action :set_application
  before_action :set_accessibility, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @projects = Project.all-@application.projects
    @accessibility = @application.accessibilities.new
  end
  
  def edit
    @projects = Array(@accessibility.project)
  end
  
  def create
    @accessibility = @application.accessibilities.new(search_accessibility_params)

    respond_to do |format|
      if @accessibility.save
        format.html { redirect_to @application, notice: 'Accessibility was successfully created.' }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @accessibility.update(search_accessibility_params)
        format.html { redirect_to @application, notice: 'Accessibility was successfully updated.' }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @accessibility.destroy
    respond_to do |format|
      format.html { redirect_to @application, notice: 'Accessibility was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Search::Application.find(params[:application_id])
    end
    
    def set_accessibility
      @accessibility = @application.accessibilities.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def search_accessibility_params
      params.require(:search_accessibility).permit(:project_id, :access, :application_id)
    end
    
end
end