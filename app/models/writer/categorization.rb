module Writer
  class Categorization < ApplicationRecord
    # t.integer   :category_id
    # t.integer   :document_id
    # t.integer   :categorizer_id
    # t.timestamps

    belongs_to :categorizer, class_name: 'Person'
    belongs_to :category_node, counter_cache: true
    belongs_to :document

    delegate :title, :slug, to: :document

    scope :created_at_desc, -> { order(created_at: :desc) }

    def to_param
      slug
    end

  end
end