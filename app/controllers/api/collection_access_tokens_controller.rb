class Api::CollectionAccessTokensController < Api::BaseController
  load_and_authorize_resource :collection, class: 'Oread::Application'
  load_and_authorize_resource :access_token, through: :collection, class: 'Oread::AccessToken', parent: false, param_method: :collection_access_token_params

  def index
    render json: @access_tokens.where(resource_owner_id: current_user.id)
  end

  def show
    render json: @access_token
  end
  
  def create
    @access_token.resource_owner = current_user
    @access_token.token_type = 'Token' if @access_token.token_type.blank?
    if @access_token.save
      render status: :created, json: @access_token
    else
      render json: @access_token.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @access_token.destroy
    head :no_content
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_access_token_params
      params.permit(:token, :token_type, :refresh_token, :expires_in)
    end

end