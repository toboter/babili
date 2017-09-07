class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :member_ids

  def member_ids
    object.members.order(id: :asc).map(&:id) if object.members.any?
  end

end
