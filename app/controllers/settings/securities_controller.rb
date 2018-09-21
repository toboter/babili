class Settings::SecuritiesController < ApplicationController
  before_action :authenticate_user!
  layout "settings"

  def show
    set_meta_tags title: "Security overview | Settings",
                  description: "Personal security overview and action audits",
                  noindex: true,
                  nofolow: true
    @audits = current_user.audits.order(created_at: :desc).limit(20)
    @recent_sessions = current_user.user_sessions
  end
end
