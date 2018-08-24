# Eine mention bindet an ein mentionable objekt. Es kann sich als namespace um eine Person 
# oder Organisation handen.

# mentionable_id:integer
# mentionable_type:string
# mentionee_id:integer
# mentioner_id:integer


#  remove -> person.mentions.create
# person.mentions: mentionable_type/mentionable_id


class Mention < ApplicationRecord
  belongs_to :mentionable, polymorphic: true
  belongs_to :mentionee, class_name: 'Namespace'
  belongs_to :mentioner, class_name: 'Person'

end