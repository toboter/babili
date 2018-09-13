module Writer
  module Category
    class Help < CategoryNode
      has_many :pages, class_name: 'Writer::Categorization', foreign_key: :category_node
    end
  end
end