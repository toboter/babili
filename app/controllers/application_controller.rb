class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_blogs
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, :alert => exception.message }
    end
  end
  
  def get_blogs
    @nav_blogs = Blog.all
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:honorific_prefix, :given_name, :middle_name, :family_name, :honorific_suffix, :birthday, :gender, :about_me])
  end

end