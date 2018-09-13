module Writer
  module Category
    class Blog < CategoryNode
      has_many :postings, class_name: 'Writer::Categorization', foreign_key: :category_node
      # limit depth: 1
    end
  end
end