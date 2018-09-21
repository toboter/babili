class Biblio::ImportsController < ApplicationController

  def new
    set_meta_tags title: 'Import | Bibliographic references',
                  description: 'Import bibliographic references into babylon-online',
                  noindex: true,
                  nofollow: true
    @repository = Repository.find(params[:repo_id])
    @referencation = Biblio::Referencation.new(repository_id: @repository.id, creator: current_person)
    authorize! :add_reference, @referencation
    @import = Biblio::Import.new(repository: @repository)
  end

  def create
    @import = Biblio::Import.new(import_params)
    @import.creator = current_person
    @import.repository = Repository.find(import_params[:repository])
    @repository = @import.repository

    authorize! :update, @repository
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