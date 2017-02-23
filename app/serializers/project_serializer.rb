class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :members

  def members
    object.members.order(id: :asc).map(&:id).join(', ') if object.members.any?
  end

end
