# Ein mentionee bindet an ein comment objekt. Es kann sich als namespace um eine Person 
# oder Organisation handen.

# comment_id:integer
# namespace_id:integer

module Discussion
  class Metionee < ApplicationRecord
    belongs_to :comment
    belongs_to :namespace
  
  end
end