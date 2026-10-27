class Aggregation::IdentifiersController < ApplicationController
  load_and_authorize_resource except: :index

  def index
    set_meta_tags title: "BOI | Babylon Object Identifiers",
                  description: "Listing Babylon Object Identifiers (BOI)",
                  noindex: true,
                  follow: true

    @q = params[:q].to_s.strip
    @identifiers = Aggregation::Identifier
      .accessible_by(current_ability)
      .search(@q)
      .includes(:items)
      .ordered
  end

  def show
    set_meta_tags title: "#{@identifier.name} | BOI",
                  description: "BOI detail for #{@identifier.name}",
                  index: true,
                  follow: true

    @items = @identifier.items.includes(:repository, :identifier, :commits).order(:slug)
    @related_identifiers = @identifier.related_identifiers.ordered
  end
end
