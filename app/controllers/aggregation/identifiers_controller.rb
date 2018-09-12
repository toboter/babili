class Aggregation::IdentifiersController < ApplicationController
  load_and_authorize_resource except: :index

  def index
    @identifiers = Aggregation::Identifier.accessible_by(current_ability)
  end

  def show
  end

end