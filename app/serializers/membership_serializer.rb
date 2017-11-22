class MembershipSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :url, :state, :role, :project_url, :project, :user

  def url
    api_project_membership_url(object.project, object)
  end

  def state
    object.verified? ? 'active' : 'pending'
  end

  def project_url
    api_project_url(object.project)
  end

  attribute :project do
    {
      name: object.project.try(:name),
      url: url_for([:api, object.project]),
      id: object.project.try(:id),
      members_url: api_project_members_url(object.project),
      avatar_url: object.project.image_url(:original),
      type: 'Project'
    }
  end

  attribute :user do
    {
      username: object.user.try(:username),
      url: url_for([:api, object.user]),
      html_url: profile_url(object.user.profile),
      id: object.user.try(:id),
      avatar_url: object.user.profile.image_url(:original),
      type: 'User'
    }
  end
end