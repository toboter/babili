class HomeController < ApplicationController
  
  def index
    @blog_pages = CMS::BlogPage.featured.order(created_at: :desc).limit(5)
    @exploreables = (Repository.take(3) + Vocab::Scheme.take(3)).shuffle
    @latest_references = Biblio::Entry.where("data->>'year' IS NOT NULL").order("(data ->> 'year') DESC").take(5)
  end
  
  def api
  end
  
  def about
  end
  
  def imprint
  end

  def research
    @people = Person.order("RANDOM()").limit(6).sort_by {|p| p.name}
    @organizations = Organization.order("RANDOM()").limit(4).sort_by {|p| p.name}
  end

  def collections
    @collection_apps = Oread::Application.order(name: :asc)
  end
  
  def explore
    @oread_applications = Oread::Application.order("RANDOM()")
    @showcased = Oread::Application.order("RANDOM()").first
    @vocabularies = Vocab::Scheme.order(created_at: :desc)
    @repositories = Repository.order(created_at: :desc)
  end

  def people
    @people = Person.order(family_name: :asc)
  end

  def organizations
    @organizations = Organization.order(created_at: :desc)
  end

  def repositories
    @repositories = Repository.order(created_at: :desc)
  end
  
end
