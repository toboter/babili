class Api::Biblio::ReferencationsController < Api::BaseController
  load_and_authorize_resource :namespace, except: :add_repository
  load_and_authorize_resource :repository, through: :namespace, except: :add_repository

  def index
    @entries = @repository.referencations.joins(:entry).where.not('biblio_entries.type IN (?)', ['Biblio::Serie', 'Biblio::Journal']).order('biblio_entries.slug asc').pluck('biblio_entries.id')

    query = params[:q].presence || '*'
    sorted_by = params[:sorted_by] ||= (params[:q].present? ? 'score_desc' : 'year_asc')
    sort_order = Biblio::Entry.sorted_by(sorted_by) if @entries.any?

    per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE
    per_page = nil if params[:format] == 'bibtex'

    @results = Biblio::Entry.search(query, 
      fields: [{citation: :exact}, :entry_type, :author, :editor, :title, :booktitle, :journal, :series, {year: :exact}, :publisher, :address, "tag^10", 
        :volume, :number, :note, :isbn, :url, :doi, :abstract],
      where: { id: @entries },
      misspellings: {below: 1},
      order: sort_order, 
      page: params[:page], 
      per_page: per_page)

    render json: @results, each_serializer: Biblio::EntrySerializer
  end

end