class Biblio::EntriesController < ApplicationController
  require 'will_paginate/array'
  load_and_authorize_resource except: :index
  DEFAULT_PER_PAGE = 50

  def index
    @all_entries = Biblio::Entry.all
    @entries = @all_entries
      .where.not(type: ['Biblio::Serie', 'Biblio::Journal'])
    @serials = @all_entries
      .where(type: ['Biblio::Serie', 'Biblio::Journal'])
      .order(citation_raw: :asc)
    
    query = params[:q].presence || '*'
    sorted_by = params[:sorted_by] ||= (params[:q].present? ? 'score_desc' : 'year_asc')
    sort_order = Biblio::Entry.sorted_by(sorted_by) if @all_entries.any?

    @results = Biblio::Entry.search(query, 
      fields: [{citation: :exact}, :entry_type, :author, :editor, :title, :booktitle, :journal, :series, {year: :exact}, :publisher, :address, "tag^10", 
        :volume, :number, :note, :isbn, :url, :doi, :abstract],
      where: { id: {not: @serials.ids} },
      misspellings: {below: 1},
      order: sort_order, 
      page: params[:page], 
      per_page: current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE)
    
    respond_to do |format|
      format.html
      format.json { render json: @results, each_serializer: Biblio::EntrySerializer }
      format.bibtex { render plain: (BibTeX::Bibliography.new << @results.map(&:to_bib))  }
    end
  
  end

end