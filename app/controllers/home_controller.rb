class HomeController < ApplicationController
  
  def index
  end
  
  def api
  end
  
  def help
  end
  
  def imprint
  end
  
  def contact
  end
  
  def explore
    @oread_applications = Oread::Application.order(name: :asc).all
    @oauth_applications = Doorkeeper::Application.order(name: :asc).all
    @projects = Project.order(created_at: :desc).all
    @users = User.all
  end
  
end
