# t.boolean "private", default: false, null: false

class Organization < ApplicationRecord
  has_one :handler, as: :profile, dependent: :destroy
  

end