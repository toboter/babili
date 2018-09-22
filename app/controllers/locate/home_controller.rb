class Locate::HomeController < ApplicationController

  def index
    set_meta_tags title: 'Start | Locate',
                  description: "Start page for locate",
                  index: true,
                  follow: true
  end

end