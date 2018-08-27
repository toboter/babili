# t.integer   :category_id
# t.integer   :document_id
# t.integer   :categorizer_id
# t.timestamps

module Writer
  class Categorization < ApplicationRecord
    belongs_to :categorizer, class_name: 'Person'
    belongs_to :category_node, counter_cache: true
    belongs_to :document
  end
end