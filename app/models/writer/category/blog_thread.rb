module Writer
  module Category
    class BlogThread < CategoryNode
      has_many :postings, class_name: 'Writer::Categorization', foreign_key: :category_node_id

    end
  end
end