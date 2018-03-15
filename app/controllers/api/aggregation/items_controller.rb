class Api::Aggregation::ItemsController < Api::BaseController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository, class: 'Aggregation::Item'
  
  def index
    render json: @items
  end

  def show
    render json: @item
  end

end