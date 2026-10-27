module OauthAccessibilitiesHelper
  # Labels and short explanations for OAuth app grants pushed to resource hosts (e.g. ADGB).
  OAUTH_PERMISSIONS = [
    [:can_manage,  "Manage",  "Full control of the application’s access settings on the client."],
    [:can_create,  "Create",  "Create new records in the client application."],
    [:can_read,    "Read",    "View records the client exposes to this accessor."],
    [:can_update,  "Update",  "Edit existing records."],
    [:can_destroy, "Delete",  "Delete records."],
    [:can_comment, "Comment", "Add comments on records."],
    [:can_publish, "Publish", "Publish or unpublish content."]
  ].freeze

  def oauth_permission_definitions
    OAUTH_PERMISSIONS
  end

  def oauth_permission_labels_for(accessibility)
    OAUTH_PERMISSIONS.filter_map do |attr, label, _|
      label if accessibility.public_send(attr)
    end
  end

  def oauth_accessor_kind(accessor)
    case accessor
    when Organization then "Team"
    when Person then "Person"
    else accessor.class.name.demodulize
    end
  end
end
