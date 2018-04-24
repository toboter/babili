class Biblio::UnpublishedsController < Biblio::EntriesController

  def show
    @entry = @unpublished
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @unpublished
  end

  def edit
    @authors = @unpublished.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @entry = @unpublished
  end

  def create
    @unpublished.creator = current_person
    respond_to do |format|
      if @unpublished.save
        format.html { redirect_to @unpublished, notice: "Unpublished was successfully created." }
        format.json { render :show, status: :created, location: @unpublished }
      else
        format.html { render :new }
        format.json { render json: @unpublished.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [])
  end
end