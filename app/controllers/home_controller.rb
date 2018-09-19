class HomeController < ApplicationController
  
  def index
    # @blog_pages = CMS::BlogPage.featured.order(created_at: :desc).limit(5)
    @exploreables = [] #(Repository.take(3) + Vocab::Scheme.take(3)).shuffle
    @latest_blog_postings = Writer::Categorization.order(created_at: :desc).includes(:category_node, :document).merge(Writer::CategoryNode.blog_threads).references(:category_node).group_by(&:document).take(5).map{|d,c| c.first}
    @latest_references = Biblio::Entry.where("data->>'year' IS NOT NULL").order("(data ->> 'year') DESC").take(5)
  end
  
  def api
  end
  
  def about
    @latest_blog_postings = Writer::Categorization.order(created_at: :desc).includes(:category_node, :document).merge(Writer::CategoryNode.blog_threads).references(:category_node).group_by(&:document).take(5).map{|d,c| c.first}
  end
  
  def imprint
  end

  def collections
    @collection_apps = Oread::Application.order(name: :asc)
  end
  
  def explore
    @oread_applications = Oread::Application.order("RANDOM()")
    @showcased = Oread::Application.order("RANDOM()").first
    @vocabularies = Vocab::Scheme.order(created_at: :desc)
    @repositories = Repository.order(created_at: :desc)
    @people = Person.approved.order("RANDOM()").limit(6).sort_by {|p| p.name}
    @organizations = Organization.order("RANDOM()").limit(4).sort_by {|p| p.name}
  end

  def people
    @people = Person.approved.order(family_name: :asc)
  end

  def organizations
    @organizations = Organization.order(created_at: :desc)
  end

  def repositories
    @repositories = Repository.order(created_at: :desc)
  end

  def discussions
    repository_ids = Repository.all.ids
    @threads = Discussion::Thread.where(discussable_type: 'Repository', discussable_id: repository_ids)
    query = params[:q].presence || '*'
    sorted_by = params[:sorted_by] ||= 'created_desc'
    sort_order = Discussion::Thread.sorted_by(sorted_by)

    per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : 50

    @results = Discussion::Thread.search(query, 
      fields: [:is, :title, :author, :mentions, :assignee, :body],
      where: { discussable_type: 'Repository', discussable_id: repository_ids },
      order: sort_order,
      page: params[:page], 
      per_page: per_page
      ) do |body|
      body[:query][:bool][:must] = { query_string: { query: query, default_operator: "and" } }
    end
  end
  
end
