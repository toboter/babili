class OauthGrant
  extend ActiveModel::Naming
  attr_accessor :person_id, :application_id, :application, :accessor, :accessibility_ids,
    :can_manage, :can_create, :can_read, :can_update, :can_destroy, :can_publish, :can_comment,
    :can_manage_through, :can_create_through, :can_read_through, :can_update_through, :can_destroy_through, :can_publish_through, :can_comment_through

  def initialize(attributes = {})
    @application_id = attributes[:application_id]
    @accessor_gid = attributes[:accessor_gid]
    @can_manage = false
    @can_manage_through = []
    @can_create = false
    @can_create_through = []
    @can_read = false
    @can_read_through = []
    @can_update = false
    @can_update_through = []
    @can_destroy = false
    @can_destroy_through = []
    @can_publish = false
    @can_publish_through = []
    @can_comment = false       # deprecated
    @can_comment_through = []  # deprecated
    @application = Doorkeeper::Application.find(@application_id)
    @accessor = GlobalID::Locator.locate(@accessor_gid)
    @accessibility_ids = []
  end

end

