class Biblio::EntriesController < ApplicationController
  load_and_authorize_resource except: :index
  DEFAULT_PER_PAGE = 50

  def index
    @all_entries = Biblio::Entry.all
    if params[:q].present?
      @entries = Biblio::Entry.search(params[:q], 
        fields: [{citation: :exact}, :entry_type, :author, :title, :journal, {year: :exact}, :serie, :publisher, :place, :tag, 
          :volume, :number, :note, :key, :isbn, :url, :doi, :abstract],
        where: {type: {not: ['Biblio::Serie', 'Biblio::Journal']}},
        page: params[:page], 
        per_page: user_signed_in? && current_person.per_page.present? ? current_person.per_page : DEFAULT_PER_PAGE)
    else
      @entries = @all_entries
        .where.not(type: ['Biblio::Serie', 'Biblio::Journal'])
        .order(slug: :asc).paginate(page: params[:page], per_page: user_signed_in? && current_person.per_page.present? ? current_person.per_page : DEFAULT_PER_PAGE)
    end

    @serials = @all_entries.where(type: ['Biblio::Serie', 'Biblio::Journal']).order(slug: :asc)
    respond_to do |format|
      format.html
      format.json { render json: @entries, each_serializer: Biblio::EntrySerializer }
    end
  
  end


end