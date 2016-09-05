class HomeController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end
  
  def api
  end
  
  def about
  end
  
  def imprint
  end
end
