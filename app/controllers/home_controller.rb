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
    @applications = Search::Application.all
    @projects = Project.order(created_at: :desc).limit(5)
  end
  
end
