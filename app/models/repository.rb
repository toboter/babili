class Repository < ApplicationRecord

  belongs_to :owner, class_name: 'Namespace'

end