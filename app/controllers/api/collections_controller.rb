class Api::CollectionsController < Api::BaseController
  load_and_authorize_resource class: 'Oread::Application'

  def index
    collections = Oread::Application.order(id: :asc)
    render json: collections, each_serializer: CollectionSerializer
  end

  def show
    collection = Oread::Application.find(params[:id])
    render json: collection, serializer: CollectionSerializer
  end
end