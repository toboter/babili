class Biblio::MasterthesesController < Biblio::EntriesController

  def show
    @entry = @masterthesis
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @schools = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @entry = @masterthesis
  end

  def edit
    @authors = @masterthesis.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @schools = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @entry = @masterthesis
  end

  def create
    @masterthesis.creator = current_person
    respond_to do |format|
      if @masterthesis.save
        format.html { redirect_to @masterthesis, notice: "Mastersthesis was successfully created." }
        format.json { render :show, status: :created, location: @masterthesis }
      else
        format.html { render :new }
        format.json { render json: @masterthesis.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @masterthesis.update(masterthesis_params)
        format.html { redirect_to @masterthesis, notice: "Mastersthesis was successfully updated." }
        format.json { render :show, status: :ok, location: @masterthesis }
      else
        format.html { render :edit }
        format.json { render json: @masterthesis.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @masterthesis.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Mastersthesis was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def masterthesis_params
    params.require(:biblio_masterthesis).permit(:title, :year, :month, :school_id,
      :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], :place_ids => [])
  end
end