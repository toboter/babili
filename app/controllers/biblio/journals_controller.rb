class Biblio::JournalsController < ApplicationController
  load_and_authorize_resource

  def index
    set_meta_tags title: 'Journals | Bibliographic references',
                  description: 'List of journals on babylon-online',
                  noindex: true,
                  follow: true
    @journals = Biblio::Journal.order(citation_raw: :asc).all   
    
    respond_to do |format|
      format.html
      format.json { render json: @journals, each_serializer: Biblio::JournalSerializer }
    end
  end

  def show
    set_meta_tags title: (@journal.abbr.presence || @journal.name) + ' | Journals',
                  description: @journal.name,
                  index: true,
                  follow: true
    @entry = @journal
    @discussions = @entry.referencings.where(referencing_type: 'Discussion::Comment')
    respond_to do |format|
      format.html
      format.json { render json: @journal, serializer: Biblio::JournalSerializer }
    end
  end

  def new
    set_meta_tags title: 'New | Journals',
                  description: 'Add new journal'
    @entry = @journal
  end

  def edit
    set_meta_tags title: 'Edit | Journals',
                  description: 'Edit journal'
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
    @entry = @journal
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
