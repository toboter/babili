class NamespacesController < ApplicationController
  load_and_authorize_resource

  def show
    authorize! :read, @namespace.subclass
    instance_variable_set("@#{@namespace.subclass.class.name.downcase}", @namespace.subclass)
    render "#{@namespace.subclass.class.name.downcase.pluralize}/show", location: namespace_url(@namespace)
  end

end