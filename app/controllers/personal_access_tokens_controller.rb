class PersonalAccessTokensController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  layout "settings"

  # GET /personal_access_tokens
  # GET /personal_access_tokens.json
  def index
    set_meta_tags title: 'Personal access tokens | Developer | Settings',
                  description: 'Personal access tokens for babylon-online.org',
                  noindex: true,
                  nofollow: true
    @personal_access_tokens = current_user.personal_access_tokens.order(updated_at: :desc)
  end

  # GET /personal_access_tokens/new
  def new
    set_meta_tags title: 'New | Personal access tokens | Developer | Settings'
    @personal_access_token = current_user.personal_access_tokens.new
  end

  # GET /personal_access_tokens/1/edit
  def edit
    set_meta_tags title: 'Edit | Personal access tokens | Developer | Settings'
  end

  # POST /personal_access_tokens
  # POST /personal_access_tokens.json
  def create
    @personal_access_token = current_user.personal_access_tokens.new(personal_access_token_params)

    respond_to do |format|
      if @personal_access_token.save
        flash[:personal_token] = @personal_access_token.access_token
        format.html { redirect_to personal_access_tokens_url, notice: 'Personal access token was successfully created.' }
        format.json { render :show, status: :created, location: @personal_access_token }
      else
        format.html { render :new }
        format.json { render json: @personal_access_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_access_tokens/1
  # PATCH/PUT /personal_access_tokens/1.json
  def update
    respond_to do |format|
      if @personal_access_token.update(personal_access_token_params)
        format.html { redirect_to personal_access_tokens_url, notice: 'Personal access token was successfully updated.' }
        format.json { render :show, status: :ok, location: @personal_access_token }
      else
        format.html { render :edit }
        format.json { render json: @personal_access_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_access_tokens/1
  # DELETE /personal_access_tokens/1.json
  def destroy
    @personal_access_token.destroy
    respond_to do |format|
      format.html { redirect_to personal_access_tokens_url, notice: 'Personal access token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_access_token
      @personal_access_token = current_user.personal_access_tokens.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_access_token_params
      params.require(:personal_access_token).permit(
        :description, :collections, :search, :notifications, :organizations, :user_profile, :user_email)
    end
end
