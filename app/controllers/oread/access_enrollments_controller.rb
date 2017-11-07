class Oread::AccessEnrollmentsController < ApplicationController
  before_action :authenticate_user!
  layout "settings"

  def index
    @applications = Oread::Application.order(name: :asc) #current_user.oread_applications.order(name: :asc).uniq #oread_access_tokens
    @enrollments = current_user.oread_access_enrollments
  end

  def create
    @enrollment = current_user.oread_access_enrollments.new(access_enrollments_params)
    @enrollment.creator = current_user

    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to settings_oread_enrollments_path, notice: "Successfully added #{@enrollment.application.name} to your collections." }
        format.json { render :show, status: :created, location: @enrollment }
        format.js
      else
        format.html { render :new }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def restore_default
    respond_to do |format|
      if current_user.enroll_to_default_oread_apps
        format.html { redirect_to settings_oread_enrollments_path, notice: 'Enrollments restored' }
      else
        format.html { redirect_to settings_oread_enrollments_path, warning: 'Something went wrong' }
      end
    end
  end

  def destroy
    @enrollment = current_user.oread_access_enrollments.find(params[:id])
    @enrollment.destroy
    respond_to do |format|
      format.html { redirect_to settings_oread_enrollments_path, notice: 'Enrollment was successfully removed.' }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def access_enrollments_params
      params.require(:oread_access_enrollment).permit(:application_id)
    end
end