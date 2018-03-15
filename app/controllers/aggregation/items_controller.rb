class Aggregation::ItemsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource :items, through: :repository, class: 'Aggregation::Item'
  layout 'repo'

  def index
  end

  def show
  end

  private
  def item_params
    params.require(:aggregation_item).permit(
    )
  end
end