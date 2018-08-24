

# thread_id:integer
# content:string
# changed_content:string
# author_id:integer

module Discussion
  class Title < ApplicationRecord
    belongs_to :thread, touch: true
    belongs_to :author, class_name: 'Person'
  
  end
end