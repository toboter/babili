class Api::Aggregation::IdentifiersController < Api::BaseController
  load_and_authorize_resource class: 'Aggregation::Identifier'

  def index
    render json: @identifiers
  end

  def show
    render json: @identifier
  end

end