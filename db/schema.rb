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

ActiveRecord::Schema.define(version: 20180503113852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "aggregation_commits", force: :cascade do |t|
    t.integer "item_id"
    t.integer "event_id"
    t.integer "origin_commit_id"
    t.integer "creator_id"
    t.jsonb "data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.index ["creator_id"], name: "index_aggregation_commits_on_creator_id"
    t.index ["event_id"], name: "index_aggregation_commits_on_event_id"
    t.index ["item_id"], name: "index_aggregation_commits_on_item_id"
    t.index ["origin_commit_id"], name: "index_aggregation_commits_on_origin_commit_id"
    t.index ["type"], name: "index_aggregation_commits_on_type"
  end

  create_table "aggregation_events", force: :cascade do |t|
    t.integer "repository_id"
    t.integer "creator_id"
    t.text "note"
    t.string "type"
    t.jsonb "origin"
    t.jsonb "processors"
    t.datetime "commited_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_aggregation_events_on_creator_id"
    t.index ["repository_id"], name: "index_aggregation_events_on_repository_id"
    t.index ["slug"], name: "index_aggregation_events_on_slug"
    t.index ["type"], name: "index_aggregation_events_on_type"
  end

  create_table "aggregation_identifications", force: :cascade do |t|
    t.integer "item_id"
    t.integer "identifier_id"
    t.index ["item_id", "identifier_id"], name: "index_aggregation_identifications_on_item_id_and_identifier_id"
  end

  create_table "aggregation_identifiers", force: :cascade do |t|
    t.string "origin_id"
    t.string "origin_type"
    t.string "origin_agent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["origin_id"], name: "index_aggregation_identifiers_on_origin_id"
  end

  create_table "aggregation_items", force: :cascade do |t|
    t.integer "repository_id"
    t.integer "pref_identifier_id"
    t.string "type"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pref_identifier_id"], name: "index_aggregation_items_on_pref_identifier_id"
    t.index ["repository_id"], name: "index_aggregation_items_on_repository_id"
    t.index ["slug"], name: "index_aggregation_items_on_slug"
    t.index ["type"], name: "index_aggregation_items_on_type"
  end

  create_table "aggregation_uploads", force: :cascade do |t|
    t.integer "event_id"
    t.text "file_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_aggregation_uploads_on_event_id"
  end

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

  create_table "biblio_creatorships", force: :cascade do |t|
    t.integer "agent_appellation_id"
    t.integer "entry_id"
    t.integer "position"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_appellation_id"], name: "index_biblio_creatorships_on_agent_appellation_id"
    t.index ["entry_id"], name: "index_biblio_creatorships_on_entry_id"
    t.index ["type"], name: "index_biblio_creatorships_on_type"
  end

  create_table "biblio_entries", force: :cascade do |t|
    t.string "type"
    t.integer "parent_id"
    t.jsonb "data"
    t.text "file_data"
    t.integer "creator_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "citation_raw"
    t.integer "sequential_id"
    t.index ["citation_raw", "sequential_id"], name: "index_biblio_entries_on_citation_raw_and_sequential_id", unique: true
    t.index ["creator_id"], name: "index_biblio_entries_on_creator_id"
    t.index ["data"], name: "index_biblio_entries_on_data", using: :gin
    t.index ["parent_id"], name: "index_biblio_entries_on_parent_id"
    t.index ["slug"], name: "index_biblio_entries_on_slug"
    t.index ["type"], name: "index_biblio_entries_on_type"
  end

  create_table "biblio_entry_hierarchies", id: false, force: :cascade do |t|
    t.integer "ancestor_id", null: false
    t.integer "descendant_id", null: false
    t.integer "generations", null: false
    t.index ["ancestor_id", "descendant_id", "generations"], name: "biblio_entry_anc_desc_idx", unique: true
    t.index ["descendant_id"], name: "biblio_entry_desc_idx"
  end

  create_table "biblio_referencations", force: :cascade do |t|
    t.integer "entry_id"
    t.integer "repository_id"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_biblio_referencations_on_creator_id"
    t.index ["entry_id"], name: "index_biblio_referencations_on_entry_id"
    t.index ["repository_id"], name: "index_biblio_referencations_on_repository_id"
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

  create_table "locate_datings", force: :cascade do |t|
    t.integer "place_id"
    t.integer "dating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dating_id"], name: "index_locate_datings_on_dating_id"
    t.index ["place_id"], name: "index_locate_datings_on_place_id"
  end

  create_table "locate_datings_locations", id: false, force: :cascade do |t|
    t.integer "dating_id"
    t.integer "location_id"
    t.index ["dating_id"], name: "index_locate_datings_locations_on_dating_id"
    t.index ["location_id"], name: "index_locate_datings_locations_on_location_id"
  end

  create_table "locate_locations", force: :cascade do |t|
    t.integer "place_id"
    t.geometry "loc", limit: {:srid=>3785, :type=>"geometry"}
    t.float "fuzzyness"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_locate_locations_on_creator_id"
    t.index ["loc"], name: "index_locate_locations_on_loc", using: :gist
    t.index ["place_id"], name: "index_locate_locations_on_place_id"
  end

  create_table "locate_places", force: :cascade do |t|
    t.string "type"
    t.text "description"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_locate_places_on_creator_id"
    t.index ["type"], name: "index_locate_places_on_type"
  end

  create_table "locate_toponyms", force: :cascade do |t|
    t.integer "dating_id"
    t.string "type"
    t.string "denomination"
    t.string "descriptor"
    t.string "language"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_locate_toponyms_on_creator_id"
    t.index ["dating_id"], name: "index_locate_toponyms_on_dating_id"
    t.index ["type"], name: "index_locate_toponyms_on_type"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "organization_id"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.integer "person_id"
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["person_id"], name: "index_memberships_on_person_id"
  end

  create_table "namespaces", force: :cascade do |t|
    t.integer "subclass_id"
    t.string "subclass_type"
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_namespaces_on_slug", unique: true
    t.index ["subclass_id", "subclass_type"], name: "index_namespaces_on_subclass_id_and_subclass_type"
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

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "image_data"
    t.text "description"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false, null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "people", id: :serial, force: :cascade do |t|
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
    t.jsonb "settings"
    t.index ["slug"], name: "index_people_on_slug", unique: true
    t.index ["user_id"], name: "index_people_on_user_id"
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

  create_table "repositories", force: :cascade do |t|
    t.integer "namespace_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.string "slug"
    t.jsonb "settings"
    t.text "readme"
    t.index ["creator_id"], name: "index_repositories_on_creator_id"
    t.index ["namespace_id"], name: "index_repositories_on_namespace_id"
    t.index ["slug"], name: "index_repositories_on_slug"
  end

  create_table "repository_classes", id: :serial, force: :cascade do |t|
    t.string "repo_api_url"
    t.integer "repository_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
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
    t.integer "person_id"
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vocab_associative_relations", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.string "property"
    t.integer "associatable_id"
    t.string "associatable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["associatable_id", "associatable_type"], name: "index_vocab_associative_relations_on_associatable"
    t.index ["concept_id"], name: "index_vocab_associative_relations_on_concept_id"
  end

  create_table "vocab_concepts", id: :serial, force: :cascade do |t|
    t.string "uuid"
    t.integer "scheme_id"
    t.integer "creator_id"
    t.string "type"
    t.string "status"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_vocab_concepts_on_creator_id"
    t.index ["scheme_id"], name: "index_vocab_concepts_on_scheme_id"
    t.index ["slug"], name: "index_vocab_concepts_on_slug", unique: true
    t.index ["type"], name: "index_vocab_concepts_on_type"
    t.index ["uuid"], name: "index_vocab_concepts_on_uuid", unique: true
  end

  create_table "vocab_descendants", force: :cascade do |t|
    t.string "category_type"
    t.bigint "ancestor_id"
    t.bigint "descendant_id"
    t.integer "distance"
    t.index ["ancestor_id"], name: "index_vocab_descendants_on_ancestor_id"
    t.index ["descendant_id"], name: "index_vocab_descendants_on_descendant_id"
  end

  create_table "vocab_external_concepts", force: :cascade do |t|
    t.string "uri"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "index_vocab_labels_on_concept_id"
    t.index ["creator_id"], name: "index_vocab_labels_on_creator_id"
    t.index ["type"], name: "index_vocab_labels_on_type"
  end

  create_table "vocab_links", force: :cascade do |t|
    t.string "category_type"
    t.bigint "parent_id"
    t.bigint "child_id"
    t.index ["child_id"], name: "index_vocab_links_on_child_id"
    t.index ["parent_id"], name: "index_vocab_links_on_parent_id"
  end

  create_table "vocab_notes", id: :serial, force: :cascade do |t|
    t.integer "concept_id"
    t.string "type"
    t.text "body"
    t.string "language"
    t.integer "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["concept_id"], name: "index_vocab_notes_on_concept_id"
    t.index ["creator_id"], name: "index_vocab_notes_on_creator_id"
    t.index ["type"], name: "index_vocab_notes_on_type"
  end

  create_table "vocab_schemes", id: :serial, force: :cascade do |t|
    t.string "abbr"
    t.string "title"
    t.text "definition"
    t.integer "creator_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "namespace_id"
    t.index ["abbr"], name: "index_vocab_schemes_on_abbr"
    t.index ["creator_id"], name: "index_vocab_schemes_on_creator_id"
    t.index ["namespace_id"], name: "index_vocab_schemes_on_namespace_id"
    t.index ["slug"], name: "index_vocab_schemes_on_slug", unique: true
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
    t.integer "default_appellation_id"
    t.integer "creator_id"
    t.index ["creator_id"], name: "index_zensus_agents_on_creator_id"
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
    t.integer "creator_id"
    t.index ["creator_id"], name: "index_zensus_events_on_creator_id"
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
  add_foreign_key "memberships", "organizations"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_accessibilities", "oauth_applications"
  add_foreign_key "oread_access_enrollments", "oread_applications", column: "application_id"
  add_foreign_key "oread_access_enrollments", "users", column: "creator_id"
  add_foreign_key "oread_access_enrollments", "users", column: "enrollee_id"
  add_foreign_key "people", "users"
end
