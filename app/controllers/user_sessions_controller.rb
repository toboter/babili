class UserSessionsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @session = UserSession.find(params[:id])
    @session.destroy
    respond_to do |format|
      format.html { redirect_to security_settings_url, notice: 'Successfully killed session!' }
      format.json { head :no_content }
      format.js
    end
  end
end