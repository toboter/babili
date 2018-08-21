class ReferencesController < ApplicationController
  load_and_authorize_resource

  def referenceables
    query = params[:q]
    @mentionees = Namespace.search(query)
    render json: @mentionees, each_serializer: MentioneeSerializer, adapter: :json
  end

end