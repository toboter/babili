class Biblio::PhdthesesController < Biblio::EntriesController

  def show
    @entry = @phdthesis
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @schools = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @repository = Repository.find(params[:repo_id])
    @referencation = @phdthesis.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @phdthesis
  end

  def edit
    @authors = @phdthesis.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.eager_load(:appellation_parts)).uniq
    @schools = Zensus::Appellation.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @entry = @phdthesis
  end

  def create
    @entry = @phdthesis
    @phdthesis.creator = current_person
    @repository = @phdthesis.referencations.last.repository
    respond_to do |format|
      if @phdthesis.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Phd-thesis was successfully created. #{view_context.link_to('Show '+@phdthesis.citation, @phdthesis, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @phdthesis }
      else
        format.html { render :new }
        format.json { render json: @phdthesis.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @phdthesis
    respond_to do |format|
      if @phdthesis.update(phdthesis_params)
        format.html { redirect_to @phdthesis, notice: "Phd-thesis was successfully updated." }
        format.json { render :show, status: :ok, location: @phdthesis }
      else
        format.html { render :edit }
        format.json { render json: @phdthesis.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @phdthesis.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Phd-thesis was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def phdthesis_params
    params.require(:biblio_phdthesis).permit(:title, :year, :month, :school_id,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], :place_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end