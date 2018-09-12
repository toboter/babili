class Aggregation::CommitsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_and_authorize_resource :item, through: :repository
  load_and_authorize_resource :commit, through: :item, except: :index
  layout 'repositories/base'

  def index
    @commits = @item.commits.accessible_by(current_ability)
  end

  def show
  end

end