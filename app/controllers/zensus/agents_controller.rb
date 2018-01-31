class Zensus::AgentsController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    @agents = @agents.where(type: params[:type]) if params[:type]
  end

  def show
  end

  def new
    @agent.type = params[:type]
    @agent.appellations.build do |a|
      a.appellation_parts.build
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @agent.save
        format.html { redirect_to zensus_agent_url(@agent), notice: 'Agent was successfully created.' }
        format.json { render :show, status: :created, location: @agent }
      else
        format.html { render :new }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @agent.update(agent_params)
        format.html { redirect_to zensus_agent_url(@agent), notice: "Agent was successfully updated." }
        format.json { render :show, status: :ok, location: @agent }
      else
        format.html { render :edit }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @agent.destroy
    respond_to do |format|
      format.html { redirect_to zensus_agents_path, notice: 'Agent was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
  def agent_params
    params.require(:zensus_agent).permit(
      :address, 
      :type,
      :default_appellation_id,
      appellations_attributes: [
        :id,
        :language, 
        :period, 
        :trans, 
        :_destroy,
        appellation_parts_attributes: [
          :id,
          :type,
          :body,
          :preferred,
          :_destroy
        ]
      ],
      activities_attributes: [
        :id,
        :property_id,
        :event_id,
        :note,
        :note_type,
        :_destroy
      ],
      links_attributes: [
        :id,
        :uri,
        :type
      ]
    )
  end

end