class Vocab::AATController < ApplicationController
  def index
    @concepts = Vocab::AAT.factes
  end

  def show
    @concept = Vocab::AAT.find(params[:id])
  end
  
end