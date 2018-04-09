class Biblio::ArticlesController < Biblio::EntriesController

  def create
    @article = type_class.new(article_params)
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

  # Never trust parameters from the scary internet, only allow the white list through.
  def article_params
    params.require(:biblio_article).permit(:year, :month, :title, :journal, :volume, :number,
      :pages, :note, :key, :url, :doi, :abstract, :author_ids => [], :tag_list => [])
  end
end