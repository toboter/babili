class Aggregation::HomeController < ApplicationController
  def index
    set_meta_tags title: "Identify ::data | BOI",
                  description: "Babylon Object Identifier (BOI) — index of primary object identifiers across repositories",
                  noindex: true,
                  follow: true

    scope = Aggregation::Identifier.accessible_by(current_ability)
    @identifier_count = scope.count
    @item_count = Aggregation::Item.accessible_by(current_ability).count
    @recent_identifiers = scope.includes(:items).ordered.limit(12)
  end
end
