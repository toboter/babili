class MentionsController < ApplicationController
  authorize_resource :mention, class: false

  def mentionees
    query = params[:q].to_s.strip
    @mentionees =
      if query.present?
        Namespace.search(query, limit: 20, load: true)
      else
        # Empty query: show a useful default list instead of failing/empty Searchkick.
        Namespace.order(:name).limit(20)
      end
    render template: "mentions/mentionees"
  end
end
