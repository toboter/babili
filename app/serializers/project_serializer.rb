class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :image_data, :description
end
