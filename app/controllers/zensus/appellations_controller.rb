class Zensus::AppellationsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @appellation.appellation_parts.build
  end

  def edit
  end

  def create
    respond_to do |format|
      if @appellation.save
        format.html { redirect_to zensus_name_url(@appellation), notice: 'Name was successfully created.' }
        format.json { render json: @appellation, methods: [:name] }
      else
        format.html { render :new }
        format.json { render json: @appellation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @appellation.update(appellation_params)
        format.html { redirect_to zensus_name_url(@appellation), notice: "Name was successfully updated." }
        format.json { render :show, status: :ok, location: @appellation  }
      else
        format.html { render :edit }
        format.json { render json: @appellation.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @appellation.destroy unless @appellation.agent
    respond_to do |format|
      format.html { redirect_to zensus_names_path, notice: (@appellation.agent ? 'You have to remove the name through the agent' : 'Name was successfully removed.') }
      format.json { head :no_content }
    end
  end

  private
  def appellation_params
    params.require(:zensus_name).permit(
      :language, 
      :period, 
      :trans, 
      :agent_id,
      appellation_parts_attributes: [
        :id,
        :type,
        :body,
        :preferred,
        :_destroy
      ]
    )
  end

end