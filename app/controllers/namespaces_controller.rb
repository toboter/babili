class NamespacesController < ApplicationController
  load_and_authorize_resource

  def index
    query = params[:q].presence || '*'
    @namespaces = Namespace.search(query)
    render json: @namespaces, each_serializer: NamespaceSerializer
  end

  def show
    instance_variable_set("@#{@namespace.subclass.class.name.downcase}", @namespace.subclass)
    render "#{@namespace.subclass.class.name.downcase.pluralize}/show", location: namespace_url(@namespace)
  end

end