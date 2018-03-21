class RepositoriesController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource through: :namespace

  def index
  end

  def show
    @items = @repository.items.joins(:pref_identifier).order('aggregation_identifiers.origin_id asc')
    render layout: 'repo'
  end

  def new
  end

  def edit
  end

  def edit_topics
    respond_to do |format|
      format.html { render :edit }
      format.js
    end
  end

  def create
    @repository.creator = current_person
    respond_to do |format|
      if @repository.save
        format.html { redirect_to [@namespace, @repository], notice: 'Repo was successfully created.' }
        format.json { render :show, status: :created, location: @repository }
      else
        format.html { render :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @repository.update(repository_params)
        format.html { redirect_to [@namespace, @repository], notice: "Repo was successfully updated." }
        format.json { render :show, status: :ok, location: @repository }
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_topics
    respond_to do |format|
      if @repository.update(repository_params)
        format.js
      else
        format.js { head :bad_request }
      end
    end
  end

  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to namespace_repositories_url(@namespace), notice: 'Repo was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  def repository_params
    params.require(:repository).permit(
      :name, 
      :description,
      :topic_list
    )
  end

end