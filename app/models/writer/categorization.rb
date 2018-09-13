module Writer
  class Categorization < ApplicationRecord
    # t.integer   :category_id
    # t.integer   :document_id
    # t.integer   :categorizer_id
    # t.string    :slug, :index
    # t.timestamps

    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :categorizer, class_name: 'Person'
    belongs_to :category_node, counter_cache: true
    belongs_to :document

    delegate :title, to: :document

  end
end