class Biblio::EntriesController < ApplicationController
  load_and_authorize_resource except: [:index, :new, :create]
  before_action :set_type, except: :index
  before_action :set_type_variable, except: [:index, :new, :create]
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

    per_page = current_user.try(:person).try(:per_page).present? ? current_user.person.per_page : DEFAULT_PER_PAGE

    @results = Biblio::Entry.search(query, 
      fields: [{citation: :exact}, :entry_type, :author, :editor, :title, :booktitle, :journal, :series, {year: :exact}, :publisher, :address, "tags^10", 
        :volume, :number, :note, :isbn, :url, :doi, :abstract],
      where: { id: {not: @serials.ids} },
      misspellings: {below: 1},
      order: sort_order, 
      page: params[:page], 
      per_page: per_page,
      aggs: [:author, :tags, :editor, :publisher]
      ) do |body|
        body[:query][:bool][:must] = { query_string: { query: query, default_operator: "and" } }
      end

    respond_to do |format|
      format.html
      format.json { render json: @results, each_serializer: EntrySerializer }
      format.bibtex { render plain: (BibTeX::Bibliography.new << @results.map(&:to_bib))  }
    end
  
  end

  def show
    @discussions = @entry.referencings.where(referencing_type: 'Discussion::Comment')
    respond_to do |format|
      format.html
      format.json { render json: @entry, serializer: EntrySerializer }
      format.bibtex { render plain: (BibTeX::Bibliography.new << @entry.to_bib) }
    end
  end

  def new
    @entry = type_class.new
    @names = Zensus::Appellation.all.eager_load(:appellation_parts)
    @authors = @names
    @editors = @names
    @publishers = @names
    @organizations = @names
    @schools = @names
    @institutions = @names
    @entries = Biblio::Entry.all
    @series = @entries.where(type: 'Biblio::Serie')
    @journals = @entries.where(type: 'Biblio::Journal')
    @books = @entries.where(type: 'Biblio::Book')
    @collections = @entries.where(type: 'Biblio::Collection')
    @proceedings = @entries.where(type: 'Biblio::Proceeding')
    @toponyms = Locate::Toponym.all

    @repository = Repository.find(params[:repo_id])
    @referencation = @entry.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
  end

  def edit
    @names = Zensus::Appellation.all.eager_load(:appellation_parts)
    @sorted_names = @entry.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(@names).uniq
    @authors = @sorted_names
    @editors = @sorted_names
    @publishers = @names
    @organizations = @names
    @schools = @names
    @institutions = @names
    @entries = Biblio::Entry.all
    @series = @entries.where(type: 'Biblio::Serie')
    @journals = @entries.where(type: 'Biblio::Journal')
    @books = @entries.where(type: 'Biblio::Book')
    @collections = @entries.where(type: 'Biblio::Collection')
    @proceedings = @entries.where(type: 'Biblio::Proceeding')
    @toponyms = Locate::Toponym.all
  end

  def create
    @entry = type_class.new(resource_params)
    @entry.creator = current_user.person
    @repository = @entry.referencations.last.repository
    authorize! :add_reference, @entry.referencations.last
    if params[:referenceables]
      gids = JSON.parse(params[:referenceables])['successful'].extend(Hashie::Extensions::DeepFind).deep_find_all('gid')
      @entry.referenceables << gids.map{|gid| Reference.new(referenceable_gid: gid, referencor: current_user.person) unless gid.in?(@entry.referenceables.map(&:referenceable_gid)) }.compact
    end
    respond_to do |format|
      if @entry.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "#{@type.demodulize} was successfully created. #{view_context.link_to('Show '+@entry.citation, @entry, class: 'text-strong')}".html_safe }
        format.json { render json: @entry }
      else
        format.html { render :new }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:referenceables]
      gids = JSON.parse(params[:referenceables])['successful'].extend(Hashie::Extensions::DeepFind).deep_find_all('gid')
      @entry.referenceables << gids.map{|gid| Reference.new(referenceable_gid: gid, referencor: current_user.person) unless gid.in?(@entry.referenceables.map(&:referenceable_gid)) }.compact
    end
    respond_to do |format|
      if @entry.update(resource_params)
        format.html { redirect_to @entry, notice: "#{@type.demodulize} was successfully updated." }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "#{@type.demodulize} was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  def set_type_variable
    instance_variable_set("@#{@type.demodulize.underscore}", @entry)
  end

  def set_type
    @type = type
  end
  
  def type
    Biblio::Entry.types.include?(params[:type]) ? params[:type] : "Biblio::Entry"
  end
  
  def type_class
    type.constantize
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def resource_params
    params.require("biblio_#{type.demodulize.underscore}".to_sym).permit(
      :year, 
      :month, 
      :title,
      :publisher_id,
      :edition,
      :serie,
      :howpublished,
      :journal,
      :book_id,
      :collection_id,
      :proceeding_id,
      :volume,
      :number,
      :subtype,
      :pages, 
      :chapter,
      :organization_id,
      :institution_id,
      :school_id,
      :print_isbn,
      :note, 
      :key, 
      :url, 
      :doi, 
      :abstract, 
      :tag_list,
      :author_ids => [],
      :editor_ids => [],
      :place_ids => [],
      referencations_attributes: [:id, :repository_id, :creator_id, :_destroy],
      referenceables_attributes: [:id, :referenceable_gid, :referencor_id, :_destroy]
    )

  end

end