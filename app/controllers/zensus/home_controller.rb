class Zensus::HomeController < ApplicationController

  def index
    set_meta_tags title: 'Start | Zensus',
                  description: "Start page for zensus",
                  index: true,
                  follow: true
  end

end