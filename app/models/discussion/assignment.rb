# Assignes can be added by people who own the disscussable object.

# thread_id:integer
# namespace_id:integer [accessors]
# assigner_id:integer

# Assignment
# namespace = assignee

module Discussion
  class Assignment < ApplicationRecord
    belongs_to :thread, touch: true
    belongs_to :assigner, class_name: 'Person'
    belongs_to :assignee, class_name: 'Namespace'
  
  end
end