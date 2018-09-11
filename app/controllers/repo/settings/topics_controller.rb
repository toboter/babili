class Repo::Settings::TopicsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace

  def edit
    authorize! :edit_topic, @repository
    respond_to do |format|
      format.html { render :edit }
      format.js
    end
  end

  def update
    authorize! :update_topic, @repository
    respond_to do |format|
      if @repository.update(repository_topic_params)
        format.js
      else
        format.js { head :bad_request }
      end
    end
  end

  private
  def repository_topic_params
    params.require(:repository_topic).permit(
      :topic_list
    )
  end

end