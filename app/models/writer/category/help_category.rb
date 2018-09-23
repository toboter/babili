module Writer
  module Category
    class HelpCategory < CategoryNode
      has_many :articles, class_name: 'Writer::Categorization', foreign_key: :category_node

      def name_tree
        self_and_ancestors.reverse.map(&:name).unshift('Help')
      end
    end
  end
end