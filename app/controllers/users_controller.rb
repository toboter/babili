class UsersController < ApplicationController
  before_action :authenticate_user!
  load_resource
  
  def index
    @users = User.where.not(id: current_user.id)
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'Updated user roles.' }
        format.js
      else
        format.html { redirect_to users_url, notice: 'Error.' }
      end
    end
  end
  
  def user_params
    params.require(:user).permit(:id, :is_active, :is_admin)
  end
end
