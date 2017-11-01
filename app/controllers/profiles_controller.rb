class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :find_by => :slug
  layout "settings", except: [:index, :show]

  def index
    @profiles = Profile.order(family_name: :asc)
  end

  def show
  end

  def new
    @profile = current_user.build_profile
  end

  def edit
    @profile = current_user.profile
  end

  def create
    @profile = current_user.build_profile(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to edit_current_profile_path, flash: { success: 'Profile was successfully created.' } }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to edit_current_profile_path, flash: { notice: 'Profile was updated successfully.' } }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:about_me, :family_name, :given_name, :honorific_prefix, :honorific_suffix, :image, :url, :institution, :location)
    end
end
