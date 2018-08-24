class ReferencesController < ApplicationController
  load_and_authorize_resource

  def referenceables
    query = params[:q]
    @referenceables = Searchkick.search(params[:q], 
      index_name: [Vocab::Concept, Biblio::Entry])
    render json: @referenceables, each_serializer: ReferenceableSerializer, adapter: :json
  end

end