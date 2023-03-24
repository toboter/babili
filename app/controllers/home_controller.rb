class HomeController < ApplicationController

  def index
    set_meta_tags title: 'Start',
                  description: 'The babylon-online homepage',
                  index: true,
                  follow: true
    @latest_blog_postings = Writer::Categorization.order(created_at: :desc).includes(:category_node, :document).merge(Writer::CategoryNode.blog_threads).references(:category_node).group_by(&:document).take(5).map{|d,c| c.first}
    @latest_references = Biblio::Entry.where(Arel.sql("data->>'year' IS NOT NULL")).order(Arel.sql("(data ->> 'year') DESC")).take(5)
    @featured_application = Oread::Application.first
  end

  def google_confirmation
    render plain: 'google-site-verification: google2a2517cd9855149e.html'
  end

  def about
    set_meta_tags title: 'About',
                  description: 'Info about babylon-online',
                  index: true,
                  follow: true
    @latest_blog_postings = Writer::Categorization.order(created_at: :desc).includes(:category_node, :document).merge(Writer::CategoryNode.blog_threads).references(:category_node).group_by(&:document).take(5).map{|d,c| c.first}
  end

  def collections
    set_meta_tags title: 'Collections',
                  description: 'Data provider apps',
                  noindex: true,
                  nofollow: true
    @collection_apps = Oread::Application.order(name: :asc)
  end

  def explore
    set_meta_tags title: 'Explore',
                  description: 'Entrypoint to explore babylon-online',
                  index: true,
                  follow: true
    @oread_applications = Oread::Application.order("RANDOM()")
    @showcased = Oread::Application.order("RANDOM()").first
    @vocabularies = Vocab::Scheme.order(created_at: :desc)
    @repositories = Repository.order(created_at: :desc)
    @people = Person.approved.order("RANDOM()").limit(6).sort_by {|p| p.name}
    @organizations = Organization.order("RANDOM()").limit(4).sort_by {|p| p.name}
  end

  def people
    set_meta_tags title: 'Researcher',
                  description: 'List of researchers on babylon-online',
                  noindex: true,
                  follow: true
    @people = Person.approved.order(family_name: :asc)
  end

  def organizations
    set_meta_tags title: 'Organizations',
                  description: 'List of organizations on babylon-online',
                  noindex: true,
                  follow: true
    @organizations = Organization.order(created_at: :desc)
  end

  def repositories
    set_meta_tags title: 'Repositories',
                  description: 'List of repositories on babylon-online',
                  noindex: true,
                  follow: true
    @repositories = Repository.order(created_at: :desc)
  end

  def discussions
    set_meta_tags title: 'Discussions',
                  description: 'Interessting discussions on several topics',
                  noindex: true,
                  follow: true
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
