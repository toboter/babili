class Biblio::SeriesController < ApplicationController
  load_and_authorize_resource

  def index
    set_meta_tags title: 'Series | Bibliographic references',
                  description: 'List of series on babylon-online',
                  noindex: true,
                  follow: true
    @serials = Biblio::Serie.order(citation_raw: :asc).all

    respond_to do |format|
      format.html
      format.json { render json: @serials, each_serializer: Biblio::SerieSerializer }
    end
  end

  def show
    set_meta_tags title: (@serie.abbr.presence || @serie.name) + ' | Series',
                  description: "#{@serie.name} #{@serie.note}",
                  index: true,
                  follow: true
    @entry = @serie
    @discussions = @entry.referencings.where(referencing_type: 'Discussion::Comment')
    respond_to do |format|
      format.html
      format.json { render json: @serie, serializer: Biblio::SerieSerializer }
    end
  end

  def new
    set_meta_tags title: 'New | Series',
                  description: 'Add new serie'
    @creators = Zensus::Appellation.all.eager_load(:appellation_parts)
    @entry = @serie
  end

  def edit
    set_meta_tags title: 'Edit | Series',
                  description: 'Edit serie'
    @creators = @serie.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @entry = @serie
  end
    
  def create
    @serie.creator = current_person
    respond_to do |format|
      if @serie.save
        format.html { redirect_to @serie, notice: "Serie was successfully created." }
        format.json { render json: @serie }
      else
        format.html { render :new }
        format.json { render json: @serie.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @serie
    respond_to do |format|
      if @serie.update(serie_params)
        format.html { redirect_to @serie, notice: "Serie was successfully updated." }
        format.json { render :show, status: :ok, location: @serie }
      else
        format.html { render :edit }
        format.json { render json: @serie.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @serie.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Serie was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def serie_params
    params.require(:biblio_serie).permit(:title, :abbr, :key, :note, :print_issn, :url, :tag_list, :editor_ids => [])
  end
end
