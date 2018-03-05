#vocab scheme
#t.integer "definer_id"
#t.string "definer_type"
# -> namespace/vocabularies
# -> namespace/repositories

class RepositoriesController < ApplicationController
  load_and_authorize_resource :namespace
  load_and_authorize_resource through: :namespace

  def index

  end

  def show

  end

end