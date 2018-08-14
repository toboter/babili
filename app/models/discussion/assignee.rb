# Assignes can be added by people who own the disscussable object.

# thread_id:integer
# namespace_id:integer [accessors]
# assigner_id:integer

module Discussion
  class Assignee < ApplicationRecord
    belongs_to :thread
    belongs_to :assigner, class_name: 'Person'
    belongs_to :namespace
  
  end
end