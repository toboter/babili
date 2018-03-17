class MembersController < ApplicationController
  load_resource :namespace
  load_resource :subclass, through: :namespace, singleton: true
  load_and_authorize_resource through: :subclass, through_association: :members, class: :person

  def index
    @members = @members.order(family_name: :asc)
  end

end