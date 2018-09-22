class Aggregation::ItemsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_and_authorize_resource :item, through: :repository, except: :index
  layout 'repositories/base'

  def index
    set_meta_tags title: "Data items | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Listing data items for #{@repository.name_tree.reverse.join(' | ')}",
                  noindex: true,
                  follow: true
    @items = @repository.items.accessible_by(current_ability).order(slug: :asc)
  end

  def show
    set_meta_tags title: "#{@item.name} | Data items | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Detail view of #{@item.name} in #{@repository.name_tree.reverse.join(' | ')}",
                  noindex: true,
                  follow: true
  end

  private
  def item_params
    params.require(:aggregation_item).permit(
    )
  end
end