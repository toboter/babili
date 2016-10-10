class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
    @users = User.where.not(id: current_user.id)
  end

  def update
    respond_to do |format|
      if @user.is_admin == true
        @user.update(is_admin: false)
        format.html { redirect_to users_url, notice: 'Admin role revoked.' }
      elsif @user.is_admin == false
        @user.update(is_admin: true)
        format.html { redirect_to users_url, notice: 'User is admin now.' }
      else
        format.html { redirect_to users_url, notice: 'Error.' }
      end
    end
  end

end
