class Vocab::HomeController < ApplicationController

  def index
    set_meta_tags title: 'Start | Vocabularies',
                  description: "Listing vocabulary schemes",
                  noindex: true,
                  follow: true
    @schemes = Vocab::Scheme.all
  end

end