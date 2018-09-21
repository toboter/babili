class OauthAccessibilitiesController < ApplicationController
  before_action :set_oauth_application
  before_action :authenticate_user!
  load_and_authorize_resource :oauth_accessibility, except: :new
  layout 'settings'

  # after_action :send_client_hook
  def index
    set_meta_tags title: 'OAuth application accessibilities | Developer | Settings',
                  description: 'OAuth application accessibilities',
                  noindex: true,
                  nofollow: true
    @accessibilities = @oauth_application.accessibilities.order(created_at: :desc)
  end

  def new
    set_meta_tags title: 'New | OAuth application accessibilities | Developer | Settings'
    authorize! :create_accessibility, @oauth_application
    @accessors = Organization.where.not(id: @oauth_application.organization_accessor_ids) + Person.approved.where.not(id: @oauth_application.person_accessor_ids)
    @oauth_accessibility = @oauth_application.accessibilities.new
  end

  def edit
  end
  
  def create
    set_meta_tags title: 'Edit | OAuth application accessibilities | Developer | Settings'
    @oauth_accessibility = @oauth_application.accessibilities.new(oauth_accessibility_params)
    @oauth_accessibility.creator = current_person
    person_ids = @oauth_accessibility.accessor.class.name == 'Organization' ? @oauth_accessibility.accessor.member_ids : [@oauth_accessibility.accessor_id]
    
    respond_to do |format|
      if @oauth_accessibility.save
        UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
        format.html { redirect_to edit_oauth_application_path(@oauth_application), notice: 'Accessibility was successfully created.' }
        format.json { render :show, status: :created, location: @oauth_application }
      else
        format.html { render :new }
        format.json { render json: @oauth_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    person_ids = @oauth_accessibility.accessor.class.name == 'Organization' ? @oauth_accessibility.accessor.member_ids : [@oauth_accessibility.accessor_id]
    respond_to do |format|
      if @oauth_accessibility.update(oauth_accessibility_params)
        UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
        format.html { redirect_to edit_oauth_application_path(@oauth_application), flash: { success: "Accessibility was successfully updated." } }
        format.json { render :show, status: :ok, location: @oauth_application }
      else
        format.html { render :edit }
        format.json { render json: @oauth_application.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_accessibilities_to_app
    person_ids = []
    @oauth_application.accessibilities.each do |acc|
      person_ids << (acc.accessor.class.name == 'Organization' ? acc.accessor.member_ids : [acc.accessor_id])
    end
    respond_to do |format|
      if person_ids.flatten.uniq
        UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids.flatten.uniq)
        format.html { redirect_to edit_oauth_application_path(@oauth_application), flash: { success: "Updating accessibilities." } }
        format.js { render js: "toastr.info('Updating');", status: :ok }
      else
        format.html { redirect_to edit_oauth_application_path(@oauth_application), flash: { error: "Nothing updated." } }
        format.js { render js: "toastr.error('Error');", status: :error }
      end
    end
  end

  def destroy
    person_ids = @oauth_accessibility.accessor.class.name == 'Organization' ? @oauth_accessibility.accessor.member_ids : [@oauth_accessibility.accessor_id]
    @oauth_accessibility.destroy
    UpdateAppAccessorsJob.perform_later(@oauth_application.id, person_ids)
    respond_to do |format|
      format.html { redirect_to edit_oauth_application_path(@oauth_application), notice: 'Accessibility was successfully removed.' }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_oauth_application
      @oauth_application = Doorkeeper::Application.find(params[:oauth_application_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def oauth_accessibility_params
      params.require(:oauth_accessibility).permit(:accessor_gid, :application_id, 
        :can_manage, :can_create, :can_read, :can_update, :can_destroy, :can_comment, :can_publish)
    end
    
end