class MembershipsController < ApplicationController
  load_resource :namespace
  load_resource :subclass, through: :namespace, singleton: true
  load_resource :memberships, through: :subclass, singleton: true

  def index
    set_meta_tags title: 'Members | ' + @namespace.name,
                  description: 'Team members page',
                  noindex: true,
                  follow: true
    @memberships = @memberships.joins(:person).merge(Person.order(family_name: :asc))
  end

end