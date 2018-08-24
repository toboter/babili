# The state of a thread indicates the current state of the discussion on that topic. It can be changed
# to closed or locked by anyone who is assigned or the author of the thread or the owner of 
# the disscussable object. It is opened automatically by a new comment.

# thread_id:integer
# content:string -> %w[open close locked]
# setter_id:integer

module Discussion
  class State < ApplicationRecord
    belongs_to :thread, touch: true
    belongs_to :setter, class_name: 'Person'

    TYPES = %w(open close lock unlock)

  end
end