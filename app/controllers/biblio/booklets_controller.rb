class Biblio::BookletsController < Biblio::EntriesController

  def show
    @entry = @booklet
  end

  def new 
    @creators = Zensus::Appellation.all
    @entry = @booklet
  end

  def edit
    @creators = @booklet.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all).uniq
    @entry = @booklet
  end

  def create
    @booklet.creator = current_person
    respond_to do |format|
      if @booklet.save
        format.html { redirect_to @booklet, notice: "Booklet was successfully created." }
        format.json { render :show, status: :created, location: @booklet }
      else
        format.html { render :new }
        format.json { render json: @booklet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booklet.update(booklet_params)
        format.html { redirect_to @booklet, notice: "Booklet was successfully updated." }
        format.json { render :show, status: :ok, location: @booklet }
      else
        format.html { render :edit }
        format.json { render json: @booklet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booklet.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Booklet was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def booklet_params
    params.require(:biblio_booklet).permit(:year, :month, :title, :howpublished,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], :place_ids => [])
  end
end