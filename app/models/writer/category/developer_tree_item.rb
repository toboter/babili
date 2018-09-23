module Writer
  module Category
    class DeveloperTreeItem < CategoryNode
      friendly_id :name, use: :scoped, scope: [:type, :parent]
      has_many :articles, class_name: 'Writer::Categorization', foreign_key: :category_node

      def name_tree
        self_and_ancestors.reverse.map(&:name).unshift('Developer')
      end
    end
  end
end