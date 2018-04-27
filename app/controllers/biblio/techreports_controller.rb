class Biblio::TechreportsController < Biblio::EntriesController

  def show
    @entry = @techreport
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @institutions = Zensus::Appellation.all.eager_load(:appellation_parts)
    @repository = Repository.find(params[:repo_id])
    @referencation = @techreport.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @techreport
  end

  def edit
    @authors = @techreport.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @institutions = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @techreport
  end

  def create
    @entry = @techreport
    @techreport.creator = current_person
    @repository = @techreport.referencations.last.repository
    respond_to do |format|
      if @techreport.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Techreport was successfully created. #{view_context.link_to('Show '+@techreport.citation, @techreport, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @techreport }
      else
        format.html { render :new }
        format.json { render json: @techreport.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @techreport
    respond_to do |format|
      if @techreport.update(techreport_params)
        format.html { redirect_to @techreport, notice: "Techreport was successfully updated." }
        format.json { render :show, status: :ok, location: @techreport }
      else
        format.html { render :edit }
        format.json { render json: @techreport.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @techreport.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Techreport was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def techreport_params
    params.require(:biblio_techreport).permit(:title, :year, :month, :institution_id, :subtype, :serie, :number,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], place_ids: [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end