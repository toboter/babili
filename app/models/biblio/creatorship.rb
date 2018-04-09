class Biblio::Creatorship < ApplicationRecord
  belongs_to :agent_appellation, class_name: 'Zensus::Appellation'
  belongs_to :entry

end
