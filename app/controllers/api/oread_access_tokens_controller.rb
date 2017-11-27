# deprecated

class Api::OreadAccessTokensController < Api::BaseController
  load_and_authorize_resource :user, only: %i[create]

  def create
    # raise oread_access_token_params.inspect
    # raise current_user.inspect
    @application = Oread::Application.find_by_host_and_port(oread_access_token_params[:host], oread_access_token_params[:port])
    if @application
      if current_user && @application
        token_type = oread_access_token_params[:token_type] || 'Token'
        @token = @application.access_tokens.create(resource_owner: current_user, token: oread_access_token_params[:token], token_type: token_type)
        render status: 200, json: @application.to_json
      else
        render status: 403, json: 'not allowed'
      end
    else
      render status: 404, json: 'Application not found.'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def oread_access_token_params
      params.permit(:host, :port, :token, :token_type)
    end

end