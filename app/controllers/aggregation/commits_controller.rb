class Aggregation::CommitsController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource :repository, through: :namespace
  load_and_authorize_resource :item, through: :repository
  load_and_authorize_resource through: :item
  layout 'repositories/base'

  def index
  end

  def show
  end

end