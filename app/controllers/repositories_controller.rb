class RepositoriesController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace

  def index
    set_meta_tags title: 'Repositories | ' + @namespace.name,
                  description: 'Repositories index page',
                  noindex: true,
                  follow: true
  end

  def show
    set_meta_tags title: @repository.name_tree.reverse.join(' | ') + ' | Repositories',
                  description: 'Repository root page'

    @items = @repository.items.joins(:identifier).order('aggregation_identifiers.origin_id asc')
    render layout: 'repositories/base'
  end

  def new
  end

  def edit
    respond_to do |format|
      format.html { render :edit, layout: 'repositories/base' }
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
        format.js
      else
        format.html { render :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
        format.js { render js: "toastr['error'](#{@repository.errors.full_messages});", status: 422 }
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
      :description,
    )
  end

end