class Zensus::AgentsController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    set_meta_tags title: 'Agents | Zensus',
                  description: "Listing agents (individuals and groups) from Zensus",
                  noindex: true,
                  follow: true
    @agents = @agents.where(type: params[:type]) if params[:type]
  end

  def show
    set_meta_tags title: "#{@agent.default_name} | Agents",
                  description: "Detail view for #{@agent.type.demodulize.downcase} #{@agent.default_name}",
                  index: true,
                  follow: true
  end

  def new
    set_meta_tags title: "New | Agents"
    @agent = Zensus::Agent.new(type: params[:type])
    @agent.appellations.build do |a|
      a.appellation_parts.build
    end
  end

  def edit
    set_meta_tags title: "Edit | Agents"
  end

  def create
    @agent.creator = current_person
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
      appellation_ids: [],
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