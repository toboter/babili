class OrganizationsController < ApplicationController
  load_and_authorize_resource
  
  def index
    raise @organizations.inspect
  end

  def show
  end

end