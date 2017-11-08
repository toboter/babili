class UserSession < ActiveRecord::Base
  def self.deactivate(session_id)
    where(session_id: session_id).delete_all
  end

  def agent
    Browser.new(user_agent)
  end

  def device
    agent.device.mobile? ? 'mobile' : 'desktop'
  end
end