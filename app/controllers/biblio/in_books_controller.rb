class Biblio::InBooksController < Biblio::EntriesController

  def show
    @entry = @in_book
  end

  def new 
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @books = Biblio::Book.all
    @entry = @in_book
  end

  def edit
    @authors = @in_book.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @books = Biblio::Book.all
    @entry = @in_book
  end

  def create
    @in_book.creator = current_person
    respond_to do |format|
      if @in_book.save
        format.html { redirect_to @in_book, notice: "InBook was successfully created." }
        format.json { render :show, status: :created, location: @in_book }
      else
        format.html { render :new }
        format.json { render json: @in_book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
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
      :pages, :note, :key, :url, :doi, :abstract, :tag_list, :author_ids => [])
  end
end