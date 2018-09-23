module Writer
  module Category
    class BlogThread < CategoryNode
      has_many :postings, class_name: 'Writer::Categorization', foreign_key: :category_node_id

      def name_tree
        self_and_ancestors.reverse.map(&:name).unshift('Blog')
      end

    end
  end
end