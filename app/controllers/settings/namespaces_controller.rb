class Settings::NamespacesController < ApplicationController
  before_action :authenticate_user!
  layout "settings"


  def edit
    raise params.inspect
  end


  def update

  end


end