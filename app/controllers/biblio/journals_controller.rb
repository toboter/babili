class Biblio::JournalsController < ApplicationController
  load_and_authorize_resource

  def index
    @journals = Biblio::Journal.order(citation_raw: :asc).all   
    
    respond_to do |format|
      format.html
      format.json { render json: @journals, each_serializer: Biblio::JournalSerializer }
    end
  end

  def show
    @entry = @journal

    respond_to do |format|
      format.html { render 'biblio/entries/show' }
      format.json { render json: @journal, serializer: Biblio::JournalSerializer }
    end
  end

  def new 
    @entry = @journal
  end

  def edit
    @entry = @journal
  end
    
  def create
    @journal.creator = current_person
    respond_to do |format|
      if @journal.save
        format.html { redirect_to @journal, notice: "Journal was successfully created." }
        format.json { render json: @journal, methods: [:name_abbr] }
      else
        format.html { render :new }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to @journal, notice: "Journal was successfully updated." }
        format.json { render :show, status: :ok, location: @journal }
      else
        format.html { render :edit }
        format.json { render json: @journal.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @journal.destroy
    respond_to do |format|
      format.html { redirect_to biblio_entries_url, notice: "Journal was successfully removed." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def journal_params
    params.require(:biblio_journal).permit(:name, :abbr, :key, :note, :print_issn, :url, :tag_list)
  end
end
