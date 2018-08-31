class Biblio::Creatorship < ApplicationRecord
  belongs_to :agent_appellation, class_name: 'Zensus::Appellation'
  belongs_to :entry, optional: true

  after_create :agent_activity

  # after create add agent activity :edited, :authored
  # after destroy :remove_activity
  def agent_activity
    # activity_build.event()
  end

end
