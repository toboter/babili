# t.integer "user_id"
# t.string "family_name"
# t.string "given_name"
# t.string "honorific_prefix"
# t.string "honorific_suffix"
# t.string "url"
# t.string "institution"
# t.string "location"


class Person < ApplicationRecord
  belongs_to :user
  has_one :handler, as: :profile, dependent: :destroy

end