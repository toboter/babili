class HomeController < ApplicationController
  
  def index
  end
  
  def api
  end
  
  def about
  end
  
  def imprint
  end
  
  def contact
  end

  def projects
    @projects = Project.where(private: false).order(name: :asc)
  end

  def collections
    @collection_apps = Oread::Application.order(name: :asc)
  end
  
  def explore
    @oread_applications = Oread::Application.order("RANDOM()")
    @projects = Project.where(private: false).order("RANDOM()")
    @users = User.order("RANDOM()")
    @showcased = Oread::Application.order("RANDOM()").first
  end
  
end
