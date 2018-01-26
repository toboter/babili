class Vocab::HomeController < ApplicationController

  def index
    @schemes = Vocab::Scheme.all
  end

end