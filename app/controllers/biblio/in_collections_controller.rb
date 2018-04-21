class Biblio::InCollectionsController < Biblio::EntriesController

  def show
    @entry = @in_collection
  end

  def new 
    @creators = Zensus::Appellation.all
    @entry = @in_collection
  end

  def edit
    @creators = @in_collection.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all).uniq
    @entry = @in_collection
  end

  def create
    @in_collection.creator = current_person
    respond_to do |format|
      if @in_collection.save
        format.html { redirect_to @in_collection, notice: "InCollection was successfully created." }
        format.json { render :show, status: :created, location: @in_collection }
      else
        format.html { render :new }
        format.json { render json: @in_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @in_collection.update(in_collection_params)
        format.html { redirect_to @in_collection, notice: "InCollection was successfully updated." }
        format.json { render :show, status: :ok, location: @in_collection }
      else
        format.html { render :edit }
        format.json { render json: @in_collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @in_collection.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "InCollection was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def in_collection_params
    params.require(:biblio_in_collection).permit(:title, :collection_id,
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [])
  end
end