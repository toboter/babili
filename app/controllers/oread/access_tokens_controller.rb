class Oread::AccessTokensController < ApplicationController
  before_action :set_application
  before_action :authenticate_user!
  layout 'settings'

  def new
    @access_token = current_user.oread_access_tokens.new
  end
  
  def create
    @access_token = @application.access_tokens.new(access_token_params)
    @access_token.resource_owner = current_user

    respond_to do |format|
      if @access_token.save
        format.html { redirect_to settings_oread_enrollments_path, notice: "Token was successfully set for #{@application.name}." }
        format.json { render :show, status: :created, location: @application }
      else
        format.html { render :new }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @access_token = current_user.oread_access_tokens.find(params[:id])
    @access_token.destroy
    respond_to do |format|
      format.html { redirect_to settings_oread_enrollments_path, notice: 'Token was successfully removed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Oread::Application.find(params[:application_id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def access_token_params
      params.require(:oread_access_token).permit(:application_id, :resource_owner_id, :token, :refresh_token, :expires_in, :token_type)
    end
    
end