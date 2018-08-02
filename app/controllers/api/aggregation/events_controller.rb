class Api::Aggregation::EventsController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository, class: 'Aggregation::Event'

  def index
    @events = @events.paginate(page: params[:page], per_page: params[:per_page] || 30)
    render json: @events, meta: pagination_dict(@events), each_serializer: Aggregation::EventSerializer, adapter: :json
  end

  def show
    render json: @event, serializer: Aggregation::EventSerializer, adapter: :json
  end

  def create
    @event.type = 'Aggregation::Event::ApiRequest'
    @event.creator = current_user.person
    @event.commits.each do |commit|
      pref_identifier = Aggregation::Identifier.where(origin_id: commit.identifier[:id], origin_type: commit.identifier[:type], origin_agent_id: commit.identifier[:agent]).first_or_create  
      commit.item = Aggregation::Item.where(pref_identifier_id: pref_identifier.id, repository_id: @event.repository_id).first_or_create
      commit.item.identifiers << pref_identifier unless commit.item.identifiers.include?(pref_identifier)
      commit.data[:changeset] = commit.item.commits.any? ? HashDiff.diff(commit.payload, JSON.parse(commit.item.commits.last.try(:data).try(:[], 'payload').to_json, {:symbolize_names => true} )) : []
      commit.creator = current_user.person
    end
    if @event.save && @event.update(commited_at: Time.now)
      render status: :created, json: @event, serializer: Aggregation::EventSerializer, adapter: :json
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:event).permit(
      :note,
      commits_attributes: [:id, :type, identifier: [:id, :type, :agent], payload: {}]
    )
  end



end