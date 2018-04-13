class Biblio::ArticlesController < Biblio::EntriesController

  def show
    @entry = @article
  end

  def new 
    @creators = Zensus::Appellation.all
    @entry = @article
  end

  def edit
    @creators = @article.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all).uniq
    @entry = @article
  end

  def create
    @article.creator = current_person
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Article was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:biblio_article).permit(:year, :month, :title, :journal, :volume, :number,
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [])
  end
end