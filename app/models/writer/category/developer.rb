module Writer
  module Category
    class Developer < CategoryNode
      has_many :articles, class_name: 'Writer::Categorization', foreign_key: :category_node
    end
  end
end