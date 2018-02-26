class MembershipSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :url, :state, :role, :organization_url, :organization, :user

  def url
    api_organization_membership_url(object.organization, object)
  end

  def state
    object.verified? ? 'active' : 'pending'
  end

  def organization_url
    api_organization_url(object.organization)
  end

  attribute :organization do
    {
      name: object.organization.try(:name),
      url: url_for([:api, object.organization]),
      id: object.organization.try(:id),
      members_url: api_organization_members_url(object.organization),
      avatar_url: object.organization.image_url(:original),
      type: 'Organization'
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