class Biblio::ReferencationsController < ApplicationController
  load_and_authorize_resource :namespace, except: :add_repository
  load_and_authorize_resource :repository, through: :namespace, except: :add_repository
  layout 'repo'

  def index
    @referencations = @repository.referencations.joins(:entry).where.not('biblio_entries.type IN (?)', ['Biblio::Serie', 'Biblio::Journal']).order('biblio_entries.slug asc')
    authorize! :read, @references
  end

  def add_repository
    repository = Repository.find(ref_params[:repository_id])
    entry = Biblio::Entry.friendly.find(ref_params[:id])
    authorize! :update, repository
    # auf diesem weg fehlen die ancestor elemente, die auch zu der repo-biblio hinzugefügt werden müssen
    reference = Biblio::Referencation.new(entry_id: entry.id, repository_id: repository.id, creator_id: current_person.id)
    respond_to do |format|
      if reference.save
        format.html { redirect_to entry, notice: "Successfully added to #{repository.name}." }
        format.js
      else
        format.html { redirect_to entry, alert: "#{reference.errors}." }
        format.js
      end
    end
  end

  def add_entry
    # auf diesem weg fehlen die ancestor elemente, die auch zu der repo-biblio hinzugefügt werden müssen
    @entry = Biblio::Entry.friendly.find(ref_params[:entry_id])
    authorize! :read, @entry
    @reference = Biblio::Referencation.new(entry_id: @entry.id, repository_id: @repository.id, creator_id: current_person.id)
    respond_to do |format|
      if @reference.save
        format.html { redirect_to namespace_repository_biblio_references_url(@namespace, @repository), notice: "#{@entry.citation} successfully added to #{@repository.name}." }
        format.js
      else
        format.html { redirect_to namespace_repository_biblio_references_url(@namespace, @repository), alert: "#{@reference.errors.messages}." }
        format.js
      end
    end
  end

  def destroy
    @repository.referencations.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to namespace_repository_biblio_references_url(@namespace, @repository), notice: "Reference successfully removed from your repository." }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def ref_params
    params.permit(:id, :repository_id, :entry_id)
  end

end