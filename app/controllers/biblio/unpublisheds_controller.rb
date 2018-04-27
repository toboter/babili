class Biblio::UnpublishedsController < Biblio::EntriesController

  def show
    @entry = @unpublished
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @repository = Repository.find(params[:repo_id])
    @referencation = @unpublished.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @unpublished
  end

  def edit
    @authors = @unpublished.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @entry = @unpublished
  end

  def create
    @entry = @unpublished
    @unpublished.creator = current_person
    @repository = @unpublished.referencations.last.repository
    respond_to do |format|
      if @unpublished.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Unpublished was successfully created. #{view_context.link_to('Show '+@unpublished.citation, @unpublished, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @unpublished }
      else
        format.html { render :new }
        format.json { render json: @unpublished.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @unpublished
    respond_to do |format|
      if @unpublished.update(unpublished_params)
        format.html { redirect_to @unpublished, notice: "Unpublished was successfully updated." }
        format.json { render :show, status: :ok, location: @unpublished }
      else
        format.html { render :edit }
        format.json { render json: @unpublished.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @unpublished.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Unpublished was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def unpublished_params
    params.require(:biblio_unpublished).permit(:title, :year, :month,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end