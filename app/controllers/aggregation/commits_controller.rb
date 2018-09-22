class Aggregation::CommitsController < ApplicationController
  load_resource :namespace
  load_resource :repository, through: :namespace
  load_and_authorize_resource :item, through: :repository
  load_and_authorize_resource :commit, through: :item, except: :index
  layout 'repositories/base'

  def index
    set_meta_tags title: "Commits | #{@item.name} | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Listing commits for #{@item.name} in #{@repository.name_tree.reverse.join(' | ')}",
                  noindex: true,
                  follow: true
    @commits = @item.commits.accessible_by(current_ability)
  end

  def show
    set_meta_tags title: "Commit | #{@item.name} | #{@repository.name_tree.reverse.join(' | ')}",
                  description: "Detail for commit on #{@item.name} in #{@repository.name_tree.reverse.join(' | ')}",
                  noindex: true,
                  follow: true
  end

end