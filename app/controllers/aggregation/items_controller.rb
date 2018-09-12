class Aggregation::ItemsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_and_authorize_resource :item, through: :repository, except: :index
  layout 'repositories/base'

  def index
    @items = @repository.items.accessible_by(current_ability).order(slug: :asc)
  end

  def show
  end

  private
  def item_params
    params.require(:aggregation_item).permit(
    )
  end
end