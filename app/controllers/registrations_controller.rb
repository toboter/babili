class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  protected
  def after_update_path_for(resource)
    account_path
  end

  private
  def check_captcha
    devise_parameter_sanitizer.permit :sign_up, keys: [:slug, :email, :password, :password_confirmation, :remember_me]

    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      set_minimum_password_length
      render :new, params: resource
    end
  end



end
