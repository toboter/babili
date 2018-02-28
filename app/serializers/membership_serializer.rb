class MembershipSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :url, :state, :role, :organization_url, :organization, :person

  def url
    api_organization_membership_url(object.organization, object.person_id)
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

  attribute :person do
    {
      username: object.person.try(:username),
      url: url_for([:api, object.person]),
      html_url: person_url(object.person),
      id: object.person.try(:id),
      avatar_url: object.person.image_url(:original),
      type: 'Person'
    }
  end
end