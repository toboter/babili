class Biblio::InProceedingsController < Biblio::EntriesController

  def show
    @entry = @in_proceeding
  end

  def new 
    @creators = Zensus::Appellation.all
    @entry = @in_proceeding
  end

  def edit
    @creators = @in_proceeding.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all).uniq
    @entry = @in_proceeding
  end

  def create
    @in_proceeding.creator = current_person
    respond_to do |format|
      if @in_proceeding.save
        format.html { redirect_to @in_proceeding, notice: "InProceeding was successfully created." }
        format.json { render :show, status: :created, location: @in_proceeding }
      else
        format.html { render :new }
        format.json { render json: @in_proceeding.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [])
  end
end