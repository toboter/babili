class OreadAccessibilitiesController < ApplicationController
  before_action :set_oread_application
  before_action :set_oread_accessibility, only: [:edit, :update, :destroy]
  before_action :authenticate_user!

  def new
    @projects = Project.where.not(id: @oread_application.project_ids)
    @oread_accessibility = @oread_application.accessibilities.new
  end
  
  def create
    @oread_accessibility = @oread_application.accessibilities.new(oread_accessibility_params)
    @oread_accessibility.creator_id = current_user.id

    respond_to do |format|
      if @oread_accessibility.save
        format.html { redirect_to @oread_application, notice: 'Accessibility was successfully created.' }
        format.json { render :show, status: :created, location: @oread_application }
      else
        format.html { render :new }
        format.json { render json: @oread_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @oread_accessibility.destroy
    respond_to do |format|
      format.html { redirect_to @oread_application, notice: 'Accessibility was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oread_application
      @oread_application = Oread::Application.find(params[:application_id])
    end
    
    def set_oread_accessibility
      @oread_accessibility = @oread_application.accessibilities.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oread_accessibility_params
      params.require(:oread_accessibility).permit(:project_id, :application_id, :creator_id)
    end
    
end