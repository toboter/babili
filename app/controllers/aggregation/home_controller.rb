class Aggregation::HomeController < ApplicationController

  def index
    set_meta_tags title: "Start | Babylon Object Identifiers",
                  description: "Start page for BOI: Babylon Object Identifier",
                  noindex: true,
                  follow: true
  end

end