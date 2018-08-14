# A version is the content body of a commment. version.last gives the last comment content.

# comment_id:integer
# body:text (-> TrixEditor with Raw::FileUpload)

module Discussion
  class Version < ApplicationRecord
    belongs_to :comment, counter_cache: true
  
  end
end