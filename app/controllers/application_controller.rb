class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_blogs

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, :alert => exception.message }
    end
  end
  
  def get_blogs
    @nav_blogs = Blog.all
  end

end
