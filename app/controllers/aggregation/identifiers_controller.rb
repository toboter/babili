class Aggregation::IdentifiersController < ApplicationController
  load_and_authorize_resource except: :index

  def index
    set_meta_tags title: "Babylon Object Identifiers",
                  description: "Listing all babylon object identifiers",
                  noindex: true,
                  follow: true
    @identifiers = Aggregation::Identifier.accessible_by(current_ability)
  end

  def show
    set_meta_tags title: "#{@identifier.name} | BOI",
                  description: "BOI: Babylon object identifiers detail view of #{@identifier.name}",
                  index: true,
                  follow: true
  end

end