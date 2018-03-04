class PeopleController < ApplicationController
  load_and_authorize_resource

  def index
    @people = @people.order(family_name: :asc)
  end

  def show
  end


end
