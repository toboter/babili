class Biblio::Creatorship < ApplicationRecord
  belongs_to :agent_appellation, class_name: 'Zensus::Appellation'
  belongs_to :entry

  after_create :add_activity

  # after create add agent activity :edited, :authored
  # after destroy :remove_activity
  def agent_activity

  end

end
