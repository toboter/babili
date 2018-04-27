class Biblio::InProceedingsController < Biblio::EntriesController

  def show
    @entry = @in_proceeding
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @proceedings = Biblio::Proceeding.all
    @repository = Repository.find(params[:repo_id])
    @referencation = @in_proceeding.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @in_proceeding
  end

  def edit
    @authors = @in_proceeding.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @proceedings = Biblio::Proceeding.all
    @entry = @in_proceeding
  end

  def create
    @entry = @in_proceeding
    @in_proceeding.creator = current_person
    @repository = @in_proceeding.referencations.last.repository
    respond_to do |format|
      if @in_proceeding.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "InProceeding was successfully created. #{view_context.link_to('Show '+@in_proceeding.citation, @in_proceeding, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @in_proceeding }
      else
        format.html { render :new }
        format.json { render json: @in_proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @in_proceeding
    respond_to do |format|
      if @in_proceeding.update(in_proceeding_params)
        format.html { redirect_to @in_proceeding, notice: "InProceeding was successfully updated." }
        format.json { render :show, status: :ok, location: @in_proceeding }
      else
        format.html { render :edit }
        format.json { render json: @in_proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @in_proceeding.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "InProceeding was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def in_proceeding_params
    params.require(:biblio_in_proceeding).permit(:title, :proceeding_id,
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end