# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180124124724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "actor_id"
    t.string "action"
    t.text "action_description"
    t.string "actor_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_audits_on_actor_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "cms_blog_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_cms_blog_categories_on_slug", unique: true
  end

  create_table "cms_content_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "cms_base_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "cms_base_desc_idx"
  end

  create_table "cms_content_links", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cms_contents", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "author_id"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.jsonb "type_details"
    t.integer "parent_id"
    t.integer "category_id"
    t.datetime "published_at"
    t.index ["slug"], name: "index_cms_contents_on_slug"
  end

  create_table "cms_help_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "position"
    t.index ["slug"], name: "index_cms_help_categories_on_slug", unique: true
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "project_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.index ["project_id"], name: "index_memberships_on_project_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_accessibilities", id: :serial, force: :cascade do |t|
    t.integer "oauth_application_id"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "accessor_id"
    t.string "accessor_type"
    t.boolean "can_manage", default: false, null: false
    t.boolean "can_create", default: false, null: false
    t.boolean "can_read", default: false, null: false
    t.boolean "can_update", default: false, null: false
    t.boolean "can_destroy", default: false, null: false
    t.boolean "can_comment", default: false, null: false
    t.boolean "can_publish", default: false, null: false
    t.index ["accessor_id", "accessor_type"], name: "index_oauth_accessibilities_on_accessor_id_and_accessor_type"
    t.index ["oauth_application_id"], name: "index_oauth_accessibilities_on_oauth_application_id"
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.string "homepage_url"
    t.string "description"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oread_access_enrollments", id: :serial, force: :cascade do |t|
    t.integer "enrollee_id"
    t.integer "application_id"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_oread_access_enrollments_on_application_id"
    t.index ["creator_id"], name: "index_oread_access_enrollments_on_creator_id"
    t.index ["enrollee_id", "application_id"], name: "index_oread_access_enrollments_on_enrollee_and_application", unique: true
    t.index ["enrollee_id"], name: "index_oread_access_enrollments_on_enrollee_id"
  end

  create_table "oread_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token"
    t.string "refresh_token"
    t.integer "expires_in"
    t.string "token_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["refresh_token"], name: "index_oread_access_tokens_on_refresh_token"
    t.index ["resource_owner_id"], name: "index_oread_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oread_access_tokens_on_token"
  end

  create_table "oread_applications", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "search_path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "host"
    t.text "description"
    t.integer "owner_id"
    t.string "owner_type"
    t.integer "port"
    t.text "image_data"
    t.boolean "enroll_users_default", default: true, null: false
    t.string "uid"
    t.index ["owner_id", "owner_type"], name: "index_oread_applications_on_owner_id_and_owner_type"
  end

  create_table "personal_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.string "access_token"
    t.string "description"
    t.jsonb "scope"
    t.boolean "revoked", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_personal_access_tokens_on_access_token", unique: true
    t.index ["resource_owner_id"], name: "index_personal_access_tokens_on_resource_owner_id"
  end

  create_table "profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "about_me"
    t.string "family_name"
    t.string "given_name"
    t.string "honorific_prefix"
    t.string "honorific_suffix"
    t.text "image_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "url"
    t.string "institution"
    t.string "location"
    t.index ["slug"], name: "index_profiles_on_slug", unique: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "image_data"
    t.text "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false, null: false
    t.index ["slug"], name: "index_projects_on_slug", unique: true
  end

  create_table "repository_classes", id: :serial, force: :cascade do |t|
    t.string "repo_api_url"
    t.integer "repository_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_sessions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "session_id"
    t.string "ip"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_user_sessions_on_session_id", unique: true
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin", default: false, null: false
    t.boolean "approved", default: false, null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocab_associative_relations", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.string "property"
    t.integer "related_concept_id"
    t.string "value"
  end

  create_table "vocab_concepts", id: :serial, force: :cascade do |t|
    t.string "uuid"
    t.integer "scheme_id"
    t.integer "creator_id"
    t.string "type"
    t.string "status"
    t.string "slug"
  end

  create_table "vocab_descendants", id: :serial, force: :cascade do |t|
    t.string "category_type"
    t.integer "ancestor_id"
    t.integer "descendant_id"
    t.integer "distance"
    t.index ["ancestor_id"], name: "index_vocab_descendants_on_ancestor_id"
    t.index ["descendant_id"], name: "index_vocab_descendants_on_descendant_id"
  end

  create_table "vocab_labels", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.string "type"
    t.string "vernacular"
    t.string "historical"
    t.string "body"
    t.string "language"
    t.boolean "is_abbrevation"
    t.integer "creator_id"
  end

  create_table "vocab_links", id: :serial, force: :cascade do |t|
    t.string "category_type"
    t.integer "parent_id"
    t.integer "child_id"
    t.index ["child_id"], name: "index_vocab_links_on_child_id"
    t.index ["parent_id"], name: "index_vocab_links_on_parent_id"
  end

  create_table "vocab_notes", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.string "type"
    t.text "body"
    t.string "language"
    t.integer "creator_id"
  end

  create_table "vocab_schemes", id: :serial, force: :cascade do |t|
    t.string "abbr"
    t.string "title"
    t.text "definition"
    t.integer "definer_id"
    t.string "definer_type"
    t.integer "creator_id"
    t.string "slug"
  end

  create_table "zensus_activities", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "property_id"
    t.integer "actable_id"
    t.string "actable_type"
    t.text "note"
    t.string "note_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actable_id", "actable_type"], name: "index_zensus_activities_on_actable_id_and_actable_type"
    t.index ["event_id"], name: "index_zensus_activities_on_event_id"
    t.index ["property_id"], name: "index_zensus_activities_on_property_id"
  end

  create_table "zensus_agents", id: :serial, force: :cascade do |t|
    t.string "slug"
    t.string "type"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_zensus_agents_on_slug", unique: true
    t.index ["type"], name: "index_zensus_agents_on_type"
  end

  create_table "zensus_appellation_parts", id: :serial, force: :cascade do |t|
    t.integer "appellation_id"
    t.integer "position"
    t.string "body"
    t.string "type"
    t.boolean "preferred", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appellation_id"], name: "index_zensus_appellation_parts_on_appellation_id"
    t.index ["preferred"], name: "index_zensus_appellation_parts_on_preferred"
    t.index ["type"], name: "index_zensus_appellation_parts_on_type"
  end

  create_table "zensus_appellations", id: :serial, force: :cascade do |t|
    t.integer "agent_id"
    t.string "language"
    t.string "period"
    t.string "trans"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_zensus_appellations_on_agent_id"
  end

  create_table "zensus_event_relations", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "property_id"
    t.integer "related_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_zensus_event_relations_on_event_id"
    t.index ["property_id"], name: "index_zensus_event_relations_on_property_id"
    t.index ["related_event_id"], name: "index_zensus_event_relations_on_related_event_id"
  end

  create_table "zensus_events", id: :serial, force: :cascade do |t|
    t.string "type"
    t.string "begins_at_string"
    t.string "ends_at_string"
    t.boolean "circa", default: false, null: false
    t.integer "place_id"
    t.integer "period_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "begins_at_date"
    t.datetime "ends_at_date"
    t.index ["type"], name: "index_zensus_events_on_type"
  end

  create_table "zensus_links", id: :serial, force: :cascade do |t|
    t.integer "agent_id"
    t.string "uri"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id"], name: "index_zensus_links_on_agent_id"
  end

  add_foreign_key "audits", "users"
  add_foreign_key "memberships", "projects"
  add_foreign_key "memberships", "users"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_accessibilities", "oauth_applications"
  add_foreign_key "oread_access_enrollments", "oread_applications", column: "application_id"
  add_foreign_key "oread_access_enrollments", "users", column: "creator_id"
  add_foreign_key "oread_access_enrollments", "users", column: "enrollee_id"
  add_foreign_key "profiles", "users"
end
