class Biblio::ImportsController < ApplicationController

  def new
    @repository = Repository.find(params[:repo_id])
    @referencation = Biblio::Referencation.new(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @import = Biblio::Import.new(repository: @repository)
    authorize! :new, @import
  end

  def create
    @import = Biblio::Import.new(import_params)
    @import.creator = current_person
    @import.repository = Repository.find(import_params[:repository])
    @repository = @import.repository

    authorize! :create, @import
    respond_to do |format|
      if @import.save
        format.html { redirect_to namespace_repository_biblio_references_path(@repository.owner, @repository), notice: "BibTeX successfully imported." }
      else
        format.html { render :new }
      end
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def import_params
    params.require(:biblio_import).permit(:file, :bibtex_text, :repository)
  end

end