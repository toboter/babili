module Api::V1
  class MembershipSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers
    attributes :url, :state, :role, :organization_url, :organization, :person

    def url
      v1_organization_membership_url(object.organization, object.person_id)
    end

    def state
      object.verified? ? 'active' : 'pending'
    end

    def organization_url
      v1_organization_url(object.organization)
    end

    belongs_to :organization
    belongs_to :person
  end
end