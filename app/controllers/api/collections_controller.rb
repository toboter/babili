class Api::CollectionsController < Api::BaseController
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
    render json: collections, each_serializer: CollectionSerializer
  end

  def show
    render json: @collection, serializer: CollectionSerializer
  end

  def resource_host
    collections = Oread::Application.where(uid: params[:uid])
    authorize! :read, collections
    render json: collections, each_serializer: CollectionSerializer
  end

end