class Api::OreadAccessTokensController < Api::BaseController
  load_and_authorize_resource :user, only: %i[create]
  before_action :set_application, only: [:create]

  def create
    # raise oread_access_token_params.inspect
    if current_resource_owner.projects.map{ |p| p.oread_applications }.flatten.include?(@application)
      token_type = oread_access_token_params[:token_type] || 'Token'
      @token = @application.access_tokens.create(resource_owner: current_resource_owner, token: oread_access_token_params[:token], token_type: token_type)
      render status: 200, json: @token.to_json
    else
      render status: 403, json: 'not allowed'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Oread::Application.find_by_host(oread_access_token_params[:host])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oread_access_token_params
      params.permit(:host, :token, :token_type)
    end

end