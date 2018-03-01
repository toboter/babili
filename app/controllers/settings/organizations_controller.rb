class Settings::OrganizationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  layout "settings"

  # GET /settings/organizations
  # GET /settings/organizations.json
  def index
    @applyments = current_person.memberships.joins(:organization).where(verified: false).order('organizations.name ASC')
    @memberships = current_person.memberships.joins(:organization).where(verified: true).order('organizations.name ASC')
  end

  # GET /settings/organizations/new
  def new
    @organization = Organization.new
    @people = Person.all
    @roles = ['Member', 'Admin']
    @organization.memberships.build(person: current_person, role: 'Admin', verified: true)
  end

  # GET /settings/organizations/1/edit
  def edit
    @people = Person.all
    @roles = ['Member', 'Admin']
  end

  # POST /settings/organizations
  # POST /settings/organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to settings_organizations_path, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/organizations/1
  # PATCH/PUT /settings/organizations/1.json
  def update
    old_ids = @organization.member_ids.dup
    respond_to do |format|
      if @organization.update(organization_params)
        new_ids = Organization.find(@organization.id).member_ids
        changed_ids = (old_ids-new_ids) + (new_ids-old_ids)
        @organization.accessible_oauth_apps.each do |app|
          UpdateAppAccessorsJob.perform_later(app.id, changed_ids)
        end
        format.html { redirect_to settings_organizations_path, notice: "Organization was successfully updated." }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /settings/organizations/1
  # DELETE /settings/organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to settings_organizations_url, notice: 'Organization was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def organization_params
      params.require(:organization).permit(
        :name, 
        :image, 
        :cached_image_data, 
        :private, 
        :description, 
        memberships_attributes: [:id, :person_id, :role, :verified, :_destroy])
    end
    
end
