module DoorkeeperApplication
  extend ActiveSupport::Concern

  included do
    has_many :accessibilities, dependent: :delete_all, class_name: 'OauthAccessibility', foreign_key: 'oauth_application_id'
    has_many :organization_accessors, through: :accessibilities, source: :accessor, source_type: 'Organization'
    has_many :person_accessors, through: :accessibilities, source: :accessor, source_type: 'Person'

    def grants(accessor)
      obj = OauthGrant.new(application_id: id, accessor_gid: accessor.to_global_id)
      accessibilities.where(id: accessor.oauth_accessibilities.ids).each do |a|
        obj.can_manage = true if a.can_manage? || (a.can_create? && a.can_read? && a.can_update? && a.can_destroy? && a.can_publish? && a.can_comment?)
        obj.can_manage_through << a.accessor if a.can_manage?
        obj.can_create = true if a.can_create?
        obj.can_create_through << a.accessor if a.can_create?
        obj.can_read = true if a.can_read?
        obj.can_read_through << a.accessor if a.can_read?
        obj.can_update = true if a.can_update?
        obj.can_update_through << a.accessor if a.can_update?
        obj.can_destroy = true if a.can_destroy?
        obj.can_destroy_through << a.accessor if a.can_destroy?
        obj.can_publish = true if a.can_publish?
        obj.can_publish_through << a.accessor if a.can_publish?
        obj.can_comment = true if a.can_comment?
        obj.can_comment_through << a.accessor if a.can_comment?
        obj.accessibility_ids << a.id
      end
      obj
    end
  end
end

Doorkeeper::Application.send :include, DoorkeeperApplication