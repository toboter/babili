class Biblio::InCollectionsController < Biblio::EntriesController

  def show
    @entry = @in_collection
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @collections = Biblio::Collection.all
    @repository = Repository.find(params[:repo_id])
    @referencation = @in_collection.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @in_collection
  end

  def edit
    @authors = @in_collection.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @collections = Biblio::Collection.all
    @entry = @in_collection
  end

  def create
    @entry = @in_collection
    @in_collection.creator = current_person
    @repository = @in_collection.referencations.last.repository
    respond_to do |format|
      if @in_collection.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "InCollection was successfully created. #{view_context.link_to('Show '+@in_collection.citation, @in_collection, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @in_collection }
      else
        format.html { render :new }
        format.json { render json: @in_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @in_collection
    respond_to do |format|
      if @in_collection.update(in_collection_params)
        format.html { redirect_to @in_collection, notice: "InCollection was successfully updated." }
        format.json { render :show, status: :ok, location: @in_collection }
      else
        format.html { render :edit }
        format.json { render json: @in_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @in_collection.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "InCollection was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def in_collection_params
    params.require(:biblio_in_collection).permit(:title, :collection_id,
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end