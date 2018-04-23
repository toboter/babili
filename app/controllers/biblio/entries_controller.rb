class Biblio::EntriesController < ApplicationController
  require 'will_paginate/array'
  load_and_authorize_resource except: :index
  DEFAULT_PER_PAGE = 50

  def index
    @all_entries = Biblio::Entry.all
    @entries = @all_entries
      .where.not(type: ['Biblio::Serie', 'Biblio::Journal'])
      .order(citation_raw: :asc, sequential_id: :asc)
    @serials = @all_entries
      .where(type: ['Biblio::Serie', 'Biblio::Journal'])
      .order(citation_raw: :asc)

    if params[:q].present?
      @results = Biblio::Entry.search(params[:q], 
        fields: [{citation: :exact}, :entry_type, :author, :editor, :title, :booktitle, :journal, :series, {year: :exact}, :publisher, :address, "tag^10", 
          :volume, :number, :note, :isbn, :url, :doi, :abstract],
        where: {type: {not: ['Biblio::Serie', 'Biblio::Journal']}})
      @results = @results.to_a
    else
      @results = @entries
    end
    
    @results = @results.sort_by(&:year) unless params[:q].present?
    @results = @results.to_a.paginate(page: params[:page], per_page: current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE)
    # sorting

    respond_to do |format|
      format.html
      format.json { render json: @entries, each_serializer: Biblio::EntrySerializer }
      format.bibtex { render plain: (BibTeX::Bibliography.new << @results.map(&:to_bib))  }
    end
  
  end


end