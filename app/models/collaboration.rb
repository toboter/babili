# t.integer   :collaborator_id
# t.integer   :collaboratable_id
# t.string    :collaboratable_type
# t.boolean   :can_create
# t.boolean   :can_read
# t.boolean   :can_update
# t.boolean   :can_destroy
# t.boolean   :can_manage
# t.integer   :creator_id
# t.timestamps

class Collaboration < ApplicationRecord
  
  belongs_to :collaborator, class_name: 'Person'
  belongs_to :collaboratable, polymorphic: true
  belongs_to :creator, class_name: 'Person'

end