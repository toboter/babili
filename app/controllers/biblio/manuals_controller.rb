class Biblio::ManualsController < Biblio::EntriesController

  def show
    @entry = @manual
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @organizations = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @manual
  end

  def edit
    @authors = @manual.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @organizations = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @manual
  end

  def create
    @manual.creator = current_person
    respond_to do |format|
      if @manual.save
        format.html { redirect_to @manual, notice: "Manual was successfully created." }
        format.json { render :show, status: :created, location: @manual }
      else
        format.html { render :new }
        format.json { render json: @manual.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @manual.update(manual_params)
        format.html { redirect_to @manual, notice: "Manual was successfully updated." }
        format.json { render :show, status: :ok, location: @manual }
      else
        format.html { render :edit }
        format.json { render json: @manual.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @manual.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Manual was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def manual_params
    params.require(:biblio_manual).permit(:title, :year, :month, :edition, :organization_id,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], :place_ids => [])
  end
end