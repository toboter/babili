class MentionsController < ApplicationController
  authorize_resource :mention, class: false

  def mentionees
    query = params[:q]
    @mentionees = Namespace.search(query)
    render_with_serializer(@mentionees, each_serializer: MentioneeSerializer)
  end

end