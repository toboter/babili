class Biblio::MiscsController < Biblio::EntriesController

  def show
    @entry = @misc
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @repository = Repository.find(params[:repo_id])
    @referencation = @misc.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @misc
  end

  def edit
    @authors = @misc.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @entry = @misc
  end

  def create
    @entry = @misc
    @misc.creator = current_person
    @repository = @misc.referencations.last.repository
    respond_to do |format|
      if @misc.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Misc was successfully created. #{view_context.link_to('Show '+@misc.citation, @misc, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @misc }
      else
        format.html { render :new }
        format.json { render json: @misc.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @misc
    respond_to do |format|
      if @misc.update(misc_params)
        format.html { redirect_to @misc, notice: "Misc was successfully updated." }
        format.json { render :show, status: :ok, location: @misc }
      else
        format.html { render :edit }
        format.json { render json: @misc.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @misc.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Misc was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def misc_params
    params.require(:biblio_misc).permit(:title, :year, :month, :howpublished,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end