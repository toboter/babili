# Category / Node
# t.integer   :parent_id
# t.string    :type
# t.string    :slug
# t.string    :name
# t.integer   :sort_order
# t.integer   :creator_id
# t.integer   :categorization_count
# t.timestamps


module Writer
  class CategoryNode < ApplicationRecord
    extend FriendlyId
    has_closure_tree order: 'sort_order'

    belongs_to :creator, class_name: 'Person'
    has_many :categorizations
    has_many :documents, through: :categorizations

    friendly_id :name, use: :scoped, scope: :type

    TYPES=%w(Writer::Category::Help Writer::Category::Developer Writer::Category::Blog)

  end
end