class Biblio::ProceedingsController < Biblio::EntriesController

  def show
    @entry = @proceeding
  end

  def new 
    @editors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @publishers = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @organizations = Zensus::Appellation.all.eager_load(:appellation_parts)
    @repository = Repository.find(params[:repo_id])
    @referencation = @proceeding.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @proceeding
  end

  def edit
    @editors = @proceeding.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @publishers = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @organizations = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @proceeding
  end

  def create
    @entry = @proceeding
    @proceeding.creator = current_person
    @repository = @proceeding.referencations.last.repository
    respond_to do |format|
      if @proceeding.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Proceeding was successfully created. #{view_context.link_to('Show '+@proceeding.citation, @proceeding, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @proceeding }
      else
        format.html { render :new }
        format.json { render json: @proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @proceeding
    respond_to do |format|
      if @proceeding.update(proceeding_params)
        format.html { redirect_to @proceeding, notice: "Proceeding was successfully updated." }
        format.json { render :show, status: :ok, location: @proceeding }
      else
        format.html { render :edit }
        format.json { render json: @proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @proceeding.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Proceeding was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def proceeding_params
    params.require(:biblio_proceeding).permit(:year, :month, :title, :serie, :volume, :publisher_id, :organization_id,
      :note, :key, :print_isbn, :url, :doi, :abstract, :tag_list, :editor_ids => [], :place_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end