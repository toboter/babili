class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :data_published

  has_many :memberships
  has_many :accessibilities, serializer: AccessibilitySerializer

end
