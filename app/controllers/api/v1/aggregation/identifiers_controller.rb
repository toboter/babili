module Api::V1::Aggregation
  class IdentifiersController < Api::V1::BaseController
    load_and_authorize_resource class: 'Aggregation::Identifier'

    def index
      render json: @identifiers
    end

    def show
      render json: @identifier
    end

  end
end