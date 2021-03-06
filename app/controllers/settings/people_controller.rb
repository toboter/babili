class Settings::PeopleController < ApplicationController
  before_action :authenticate_user!
  layout "settings"

  def edit
    set_meta_tags title: "Your profile | Settings",
                  description: "General settings on the person"
    @person = current_person
  end

  def update
    @person = current_person
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to edit_settings_person_path, flash: { notice: 'Profile was updated successfully.' } }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:about_me, :agent_id, :family_name, :given_name, :image, :per_page, :csl)
    end

end