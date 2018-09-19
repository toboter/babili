module Writer
  module Category
    class DeveloperTreeItem < CategoryNode
      friendly_id :name, use: :scoped, scope: [:type, :parent]
      has_many :articles, class_name: 'Writer::Categorization', foreign_key: :category_node
    end
  end
end