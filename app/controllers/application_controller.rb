class ApplicationController < ActionController::Base
  helper JsonSerializationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_back(fallback_location: root_path, flash: { error: exception.message } ) }
    end
  end

  def current_person
    current_user.person if current_user
  end
  helper_method :current_person

  before_action :store_current_person_id

  def store_current_person_id
    RequestStore.store[:current_person_id] = current_person&.id
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:slug, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :account_update, keys: [:email, :password, :password_confirmation, :remember_me]
  end
end
