module Writer
  class CategoryNode < ApplicationRecord
    # t.integer   :parent_id
    # t.string    :type
    # t.string    :slug
    # t.string    :name
    # t.integer   :sort_order
    # t.integer   :creator_id
    # t.integer   :categorizations_count
    # t.timestamps

    extend FriendlyId
    has_closure_tree order: 'sort_order'

    belongs_to :creator, class_name: 'Person'
    has_many :categorizations, dependent: :destroy
    has_many :documents, through: :categorizations

    friendly_id :name, use: :scoped, scope: :type

    TYPES=%w(Writer::Category::Help Writer::Category::Developer Writer::Category::BlogThread)

    validates :name, presence: true

  end
end