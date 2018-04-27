class Biblio::BookletsController < Biblio::EntriesController

  def show
    @entry = @booklet
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @repository = Repository.find(params[:repo_id])
    @referencation = @booklet.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @booklet
  end

  def edit
    @authors = @booklet.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @toponyms = Locate::Toponym.all
    @entry = @booklet
  end

  def create
    @entry = @booklet
    @booklet.creator = current_person
    @repository = @booklet.referencations.last.repository
    respond_to do |format|
      if @booklet.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Booklet was successfully created. #{view_context.link_to('Show '+@booklet.citation, @booklet, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @booklet }
      else
        format.html { render :new }
        format.json { render json: @booklet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @booklet
    respond_to do |format|
      if @booklet.update(booklet_params)
        format.html { redirect_to @booklet, notice: "Booklet was successfully updated." }
        format.json { render :show, status: :ok, location: @booklet }
      else
        format.html { render :edit }
        format.json { render json: @booklet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booklet.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Booklet was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def booklet_params
    params.require(:biblio_booklet).permit(:year, :month, :title, :howpublished,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], :place_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end