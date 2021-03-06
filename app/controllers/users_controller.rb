# AccountsController

class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  layout "settings", only: [:index]
  
  def index
    set_meta_tags title: 'Users | Admin | Settings',
                  description: 'Admin users page',
                  noindex: true,
                  nofollow: true

    @users = User.order(approved: :asc, created_at: :desc) # .where.not(id: current_user.id)
  end

  def approve
    respond_to do |format|
      if @user.update(user_params)
        Audit.create!(user: @user, actor: current_user, action: "user.#{@user.approved? ? 'approved' : 'disapproved'}", actor_ip: current_user.last_sign_in_ip)
        format.html { redirect_to users_url, notice: 'Updated user approval.' }
        format.js
      else
        format.html { redirect_to users_url, notice: 'Error.' }
        format.js
      end
    end
  end

  def make_admin
    respond_to do |format|
      if current_user.is_admin? && @user.update(user_params)
        Audit.create!(user: @user, actor: current_user, action: "user.#{@user.is_admin? ? 'is_admin' : 'is_not_admin'}", actor_ip: current_user.last_sign_in_ip)
        format.html { redirect_to users_url, notice: 'Updated user roles.' }
        format.js
      else
        format.html { redirect_to settings_url, notice: 'Error.' }
        format.js
      end
    end
  end

  def destroy
    if current_user.is_admin? && current_user != @user && !@user.approved?
      @user.person.destroy
      @user.destroy
    end
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User & Person with Namespace was successfully removed.' }
      format.js
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:id, :approved, :is_admin)
  end
end
