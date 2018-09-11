class Repo::Settings::CollaborationsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_and_authorize_resource :collaboration, through: :repository, except: :index
  layout 'repositories/settings'

  def index
    authorize! :read_collaborations, @repository
    @collaborations = @repository.collaborations
    @potential_collabs = Person.all - @repository.accessors - @repository.invited_collaborators
  end

  def new
  end

  def edit
  end

  def create
    @collaboration.creator = current_user.person
    respond_to do |format|
      if @collaboration.save
        format.html { redirect_to namespace_repository_settings_collaborations_path(@namespace, @repository), notice: 'Collaboration was successfully created.' }
        format.json { render :show, status: :created, location: @collaboration }
      else
        format.html { render :index }
        format.json { render json: @collaboration.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @collaboration.update(resource_params)
        format.html { redirect_to namespace_repository_settings_collaborations_path(@namespace, @repository), notice: "Collaboration was successfully updated." }
        format.json { render :show, status: :ok, location: @collaboration }
        format.js { render js: "toastr['success']('Successfully updated collaboration!');", status: 200 }
      else
        format.html { render :edit }
        format.json { render json: @repositcollaborationory.errors, status: :unprocessable_entity }
        format.js { render js: "toastr['error'](#{@collaboration.errors.full_messages});", status: 422 }
      end
    end
  end

  def destroy
    @collaboration.destroy
    respond_to do |format|
      format.html { redirect_to namespace_repository_settings_collaborations_path(@namespace, @repository), notice: 'Collaborator was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  def resource_params
    params.require(:repository_collaboration).permit(
      :collaborator_id,
      :can_manage,
      :can_create,
      :can_read,
      :can_update,
      :can_destroy
    )
  end

end