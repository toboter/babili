class Biblio::CollectionsController < Biblio::EntriesController

  def show
    @entry = @collection
  end

  def new
    @editors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @publishers = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @organizations = Zensus::Appellation.all.eager_load(:appellation_parts)
    @repository = Repository.find(params[:repo_id])
    @referencation = @collection.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @collection
  end

  def edit
    @editors = @collection.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @publishers = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @organizations = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @collection
  end

  def create
    @entry = @collection
    @collection.creator = current_person
    @repository = @collection.referencations.last.repository
    respond_to do |format|
      if @collection.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Collection was successfully created. #{view_context.link_to('Show '+@collection.citation, @collection, class: 'text-strong')}".html_safe }
        format.json { render json: @collection, methods: [:citation] }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @collection
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: "Collection was successfully updated." }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Collection was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:biblio_collection).permit(:year, :month, :title, :serie, :volume, :publisher_id, :edition, :organization_id,
      :note, :key, :print_isbn, :url, :doi, :abstract, :tag_list, :editor_ids => [], :place_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end