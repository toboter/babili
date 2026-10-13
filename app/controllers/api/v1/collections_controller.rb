module Api::V1
  class CollectionsController < Api::V1::BaseController
    load_and_authorize_resource class: 'Oread::Application', except: :resource_host

    # included from deprecated oread_collections_controller
    # require 'rest-client'
    # require 'json'
    # include ERB::Util

    # skip_before_action :doorkeeper_authorize!
    # skip_before_action :authenticate_user_with_doorkeeper!
    # skip_authorization_check

    # before_action :authenticate_user_with_personal_token!
    # before_action  -> { authorize_personal_api_methods(:collections) }, only: :index
    

    def index
      collections = @collections.order(id: :asc)
      render_with_serializer(collections, each_serializer: CollectionSerializer)
    end

    def show
      render_with_serializer(@collection, serializer: CollectionSerializer)
    end

    def resource_host
      collections = Oread::Application.where(uid: params[:uid])
      # CanCan cannot authorize an AR relation; authorize the class (public :read) then filter.
      authorize! :read, Oread::Application
      render_with_serializer(collections, each_serializer: CollectionSerializer)
    end

  end
end