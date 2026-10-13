class ReferencesController < ApplicationController
  authorize_resource :reference, class: false

  def referenceables
    query = params[:q]
    @referenceables = Searchkick.search(params[:q], 
      index_name: [Vocab::Concept, Biblio::Entry, Discussion::Thread, Writer::Document])
    render_with_serializer(@referenceables, each_serializer: ReferenceableSerializer)
  end

end