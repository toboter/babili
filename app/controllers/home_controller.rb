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
  end
  
end
