class Biblio::CollectionsController < Biblio::EntriesController

  def show
    @entry = @collection
  end

  def new 
    @creators = Zensus::Appellation.all
    @entry = @collection
  end

  def edit
    @creators = @collection.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all).uniq
    @entry = @collection
  end

  def create
    @collection.creator = current_person
    respond_to do |format|
      if @collection.save
        format.html { redirect_to @collection, notice: "Collection was successfully created." }
        format.json { render json: @collection, methods: [:citation] }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to @collection, notice: "Collection was successfully updated." }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Collection was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:biblio_collection).permit(:year, :month, :title, :serie, :volume, :publisher_id, :edition, :organization_id,
      :note, :key, :print_isbn, :url, :doi, :abstract, :tag_list, :editor_ids => [], :place_ids => [])
  end
end