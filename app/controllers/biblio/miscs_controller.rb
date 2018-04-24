class Biblio::MiscsController < Biblio::EntriesController

  def show
    @entry = @misc
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @misc
  end

  def edit
    @authors = @misc.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @entry = @misc
  end

  def create
    @misc.creator = current_person
    respond_to do |format|
      if @misc.save
        format.html { redirect_to @misc, notice: "Misc was successfully created." }
        format.json { render :show, status: :created, location: @misc }
      else
        format.html { render :new }
        format.json { render json: @misc.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [])
  end
end