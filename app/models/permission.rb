class Permission
  include ActiveModel::Model

  attr_accessor :person, :can_create, :can_read, :can_update, :can_destroy, :can_manage, :is_owner

end