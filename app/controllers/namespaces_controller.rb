class NamespacesController < ApplicationController

  def show
    @namespace = Namespace.friendly.find(params[:id])
    instance_variable_set("@#{@namespace.subclass.class.name.downcase}", @namespace.subclass)
    render "#{@namespace.subclass.class.name.downcase.pluralize}/show", location: namespace_url(@namespace)
  end

end