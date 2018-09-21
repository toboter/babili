class NamespacesController < ApplicationController
  load_and_authorize_resource

  def show
    set_meta_tags title: @namespace.subclass.name,
                  description: 'Profile page'

    authorize! :read, @namespace.subclass
    instance_variable_set("@#{@namespace.subclass.class.name.downcase}", @namespace.subclass)
    render "#{@namespace.subclass.class.name.downcase.pluralize}/show", location: namespace_url(@namespace)
  end

end