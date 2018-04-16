class Biblio::ProceedingsController < Biblio::EntriesController

  def show
    @entry = @proceeding
  end

  def new 
    @creators = Zensus::Appellation.all
    @entry = @proceeding
  end

  def edit
    @creators = @proceeding.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all).uniq
    @entry = @proceeding
  end

  def create
    @proceeding.creator = current_person
    respond_to do |format|
      if @proceeding.save
        format.html { redirect_to @proceeding, notice: "Proceeding was successfully created." }
        format.json { render :show, status: :created, location: @proceeding }
      else
        format.html { render :new }
        format.json { render json: @proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
      :note, :key, :print_isbn, :url, :doi, :abstract, :tag_list, :editor_ids => [], :place_ids => [])
  end
end