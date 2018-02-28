class HomeController < ApplicationController
  
  def index
    @blog_pages = CMS::BlogPage.type_details_where(featured: true).order(created_at: :desc).limit(5)
  end
  
  def api
  end
  
  def about
  end
  
  def imprint
  end
  
  def contact
  end

  def organizations
    @organizations = Organization.where(private: false).order(name: :asc)
  end

  def collections
    @collection_apps = Oread::Application.order(name: :asc)
  end
  
  def explore
    @oread_applications = Oread::Application.order("RANDOM()")
    @organizations = Organization.where(private: false).order("RANDOM()")
    @people = Person.order("RANDOM()")
    @showcased = Oread::Application.order("RANDOM()").first
  end
  
end
