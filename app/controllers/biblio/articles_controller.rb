class Biblio::ArticlesController < Biblio::EntriesController

  def show
    @entry = @article
  end

  def new
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @journals = Biblio::Journal.all
    @repository = Repository.find(params[:repo_id])
    @referencation = @article.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @article
  end

  def edit
    @authors = @article.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @journals = Biblio::Journal.all
    @entry = @article
  end

  def create
    @article.creator = current_person
    @repository = @article.referencations.last.repository
    respond_to do |format|
      if @article.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "Article was successfully created. #{view_context.link_to('Show '+@article.citation, @article, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @article
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
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end