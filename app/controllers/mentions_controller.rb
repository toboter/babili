class MentionsController < ApplicationController
  authorize_resource :mention, class: false

  def mentionees
    query = params[:q]
    @mentionees = Namespace.search(query)
    render json: @mentionees, each_serializer: MentioneeSerializer, adapter: :json
  end

end