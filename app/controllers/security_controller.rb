class SecurityController < ApplicationController
  before_action :authenticate_user!
  layout "settings"

  def index
    @audits = current_user.audits.order(created_at: :desc).limit(20)
    @sessions =[]
    @sessions << OpenStruct.new(
                  ip: current_user.last_sign_in_ip, 
                  device: 'mobile', 
                  browser: 'Chrome',
                  last_access_at: Time.now,
                  signed_in_at: current_user.last_sign_in_at)
  end
end
