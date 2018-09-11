class Aggregation::ItemsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource through: :repository
  layout 'repositories/base'

  def index
    @items = @items.order(slug: :asc)
  end

  def show
  end

  private
  def item_params
    params.require(:aggregation_item).permit(
    )
  end
end