class OauthAccessibilitiesController < ApplicationController
  before_action :set_oauth_application
  before_action :authenticate_user!
  load_and_authorize_resource :oauth_accessibility, except: :new
  layout 'settings'

  # after_action :send_client_hook
  def index
    set_meta_tags title: "Access · #{@oauth_application.name} | Developer | Settings",
                  description: 'Who can use this OAuth application',
                  noindex: true,
                  nofollow: true
    @accessibilities = @oauth_application.accessibilities.includes(:accessor).order(created_at: :desc)
  end

  def new
    set_meta_tags title: "Add access · #{@oauth_application.name} | Developer | Settings"
    authorize! :create_accessibility, @oauth_application
    load_available_accessors
    @oauth_accessibility = @oauth_application.accessibilities.new
  end

  def edit
    set_meta_tags title: "Edit access · #{@oauth_application.name} | Developer | Settings"
  end

  def create
    @oauth_accessibility = @oauth_application.accessibilities.new(oauth_accessibility_params)
    @oauth_accessibility.creator = current_person
    person_ids = person_ids_for(@oauth_accessibility)

    respond_to do |format|
      if @oauth_accessibility.save
        UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
        format.html { redirect_to oauth_application_accessibilities_path(@oauth_application), notice: 'Access was added. Sync to the client when you want it applied there.' }
        format.json { render :show, status: :created, location: @oauth_application }
      else
        load_available_accessors
        format.html { render :new }
        format.json { render json: @oauth_accessibility.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    person_ids = person_ids_for(@oauth_accessibility)
    respond_to do |format|
      if @oauth_accessibility.update(oauth_accessibility_params)
        UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
        format.html { redirect_to oauth_application_accessibilities_path(@oauth_application), notice: 'Permissions updated. Sync to the client when you want it applied there.' }
        format.json { render :show, status: :ok, location: @oauth_application }
      else
        format.html { render :edit }
        format.json { render json: @oauth_accessibility.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_accessibilities_to_app
    person_ids = @oauth_application.accessibilities.flat_map { |acc| person_ids_for(acc) }.uniq
    respond_to do |format|
      if person_ids.any?
        UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
        format.html { redirect_to oauth_application_accessibilities_path(@oauth_application), notice: 'Syncing permissions to the client application…' }
        format.js { render js: "toastr.info('Syncing permissions to the client…');", status: :ok }
      else
        format.html { redirect_to oauth_application_accessibilities_path(@oauth_application), alert: 'Nothing to sync — add access first.' }
        format.js { render js: "toastr.error('Nothing to sync');", status: :error }
      end
    end
  end

  def destroy
    person_ids = person_ids_for(@oauth_accessibility)
    @oauth_accessibility.destroy
    UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
    respond_to do |format|
      format.html { redirect_to oauth_application_accessibilities_path(@oauth_application), notice: 'Access removed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_oauth_application
    @oauth_application = Doorkeeper::Application.find(params[:oauth_application_id])
  end

  def load_available_accessors
    @organizations = Organization.where.not(id: @oauth_application.organization_accessor_ids).order(:name)
    @people = Person.approved.where.not(id: @oauth_application.person_accessor_ids).sort_by(&:name)
  end

  def person_ids_for(accessibility)
    accessor = accessibility.accessor
    return [] unless accessor

    accessor.is_a?(Organization) ? accessor.member_ids : [accessor.id]
  end

  def oauth_accessibility_params
    params.require(:oauth_accessibility).permit(
      :accessor_gid, :application_id,
      :can_manage, :can_create, :can_read, :can_update, :can_destroy, :can_comment, :can_publish
    )
  end
end
