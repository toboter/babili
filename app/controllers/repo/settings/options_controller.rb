class Repo::Settings::OptionsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  layout 'repositories/settings'

  def edit
    set_meta_tags title: "Settings | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Edit repository settings"
  end

  # put
  def name
    authorize! :name, @repository
    respond_to do |format|
      if @repository.update(repository_name_params)
        format.html { redirect_to edit_namespace_repository_settings_options_path(@namespace, @repository), notice: "Repository name was successfully updated." }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def repository_name_params
    params.require(:repository_name).permit(
      :name, 
    )
  end

end