class Biblio::InBooksController < Biblio::EntriesController

  def show
    @entry = @in_book
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @books = Biblio::Book.all
    @repository = Repository.find(params[:repo_id])
    @referencation = @in_book.referencations.build(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @entry = @in_book
  end

  def edit
    @authors = @in_book.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @books = Biblio::Book.all
    @entry = @in_book
  end

  def create
    @entry = @in_book
    @in_book.creator = current_person
    @repository = @in_book.referencations.last.repository
    respond_to do |format|
      if @in_book.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "InBook was successfully created. #{view_context.link_to('Show '+@in_book.citation, @in_book, class: 'text-strong')}".html_safe }
        format.json { render :show, status: :created, location: @in_book }
      else
        format.html { render :new }
        format.json { render json: @in_book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = @in_book
    respond_to do |format|
      if @in_book.update(in_book_params)
        format.html { redirect_to @in_book, notice: "InBook was successfully updated." }
        format.json { render :show, status: :ok, location: @in_book }
      else
        format.html { render :edit }
        format.json { render json: @in_book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @in_book.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "InBook was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def in_book_params
    params.require(:biblio_in_book).permit(:title, :book_id, :chapter,
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [], referencations_attributes: [:id, :repository_id, :creator_id, :_destroy])
  end
end