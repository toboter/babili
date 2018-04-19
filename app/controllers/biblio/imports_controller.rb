class Biblio::ImportsController < ApplicationController

  def new
    @import = Biblio::Import.new
    
    authorize! :new, @import
  end

  def create
    @import = Biblio::Import.new(import_params)
    @import.creator = current_person

    authorize! :create, @import
    respond_to do |format|
      if @import.save
        format.html { redirect_to biblio_entries_path, notice: "File was successfully imported." }
      else
        format.html { render :new }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def import_params
    params.require(:biblio_import).permit(:file, :bibtex_text, repository_ids: [])
  end

end