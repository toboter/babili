class Biblio::BooksController < Biblio::EntriesController

  def show
    @entry = @book
  end

  def new
    @authors = Zensus::Appellation.all.eager_load(:appellation_parts)
    @publishers = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @entry = @book
  end

  def edit
    @authors = @book.creatorships.order(id: :asc).map{|c| c.agent_appellation }.concat(Zensus::Appellation.all.eager_load(:appellation_parts)).uniq
    @publishers = Zensus::Appellation.all.eager_load(:appellation_parts)
    @toponyms = Locate::Toponym.all
    @series = Biblio::Serie.all
    @entry = @book
  end

  def create
    @book.creator = current_person
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Book was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:biblio_book).permit(:year, :month, :title, :serie, :volume, :publisher_id, :edition,
      :note, :key, :print_isbn, :url, :doi, :abstract, :tag_list, :author_ids => [], :place_ids => [])
  end
end