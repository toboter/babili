class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_blogs
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_back(fallback_location: root_path, flash: { error: exception.message } ) }
    end
  end
  
  def get_blogs
    @nav_blogs = Blog.all
  end
  
  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end