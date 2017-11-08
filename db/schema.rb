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

ActiveRecord::Schema.define(version: 20171108151946) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "actor_id"
    t.string   "action"
    t.text     "action_description"
    t.string   "actor_ip"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["actor_id"], name: "index_audits_on_actor_id", using: :btree
    t.index ["user_id"], name: "index_audits_on_user_id", using: :btree
  end

  create_table "blogs", force: :cascade do |t|
    t.string   "type"
    t.integer  "author_id"
    t.string   "title"
    t.text     "content"
    t.string   "external_link"
    t.datetime "posted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "position"
    t.string   "slug"
    t.text     "abstract"
    t.index ["slug"], name: "index_blogs_on_slug", unique: true, using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_memberships_on_project_id", using: :btree
    t.index ["user_id"], name: "index_memberships_on_user_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_accessibilities", force: :cascade do |t|
    t.integer  "oauth_application_id"
    t.integer  "creator_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "accessor_id"
    t.string   "accessor_type"
    t.boolean  "can_manage",           default: false, null: false
    t.boolean  "can_create",           default: false, null: false
    t.boolean  "can_read",             default: false, null: false
    t.boolean  "can_update",           default: false, null: false
    t.boolean  "can_destroy",          default: false, null: false
    t.boolean  "can_comment",          default: false, null: false
    t.boolean  "can_publish",          default: false, null: false
    t.index ["accessor_id", "accessor_type"], name: "index_oauth_accessibilities_on_accessor_id_and_accessor_type", using: :btree
    t.index ["oauth_application_id"], name: "index_oauth_accessibilities_on_oauth_application_id", using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "homepage_url"
    t.string   "description"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type", using: :btree
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "oread_access_enrollments", force: :cascade do |t|
    t.integer  "enrollee_id"
    t.integer  "application_id"
    t.integer  "creator_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["application_id"], name: "index_oread_access_enrollments_on_application_id", using: :btree
    t.index ["creator_id"], name: "index_oread_access_enrollments_on_creator_id", using: :btree
    t.index ["enrollee_id", "application_id"], name: "index_oread_access_enrollments_on_enrollee_and_application", unique: true, using: :btree
    t.index ["enrollee_id"], name: "index_oread_access_enrollments_on_enrollee_id", using: :btree
  end

  create_table "oread_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token"
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.string   "token_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["refresh_token"], name: "index_oread_access_tokens_on_refresh_token", using: :btree
    t.index ["resource_owner_id"], name: "index_oread_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oread_access_tokens_on_token", using: :btree
  end

  create_table "oread_applications", force: :cascade do |t|
    t.string   "name"
    t.string   "search_path"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "host"
    t.text     "description"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "port"
    t.text     "image_data"
    t.boolean  "enroll_users_default", default: true, null: false
    t.index ["owner_id", "owner_type"], name: "index_oread_applications_on_owner_id_and_owner_type", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "about_me"
    t.string   "family_name"
    t.string   "given_name"
    t.string   "honorific_prefix"
    t.string   "honorific_suffix"
    t.text     "image_data"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "slug"
    t.string   "url"
    t.string   "institution"
    t.string   "location"
    t.index ["slug"], name: "index_profiles_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name"
    t.text     "image_data"
    t.text     "description"
    t.string   "slug"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "data_published"
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
  end

  create_table "user_sessions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "session_id"
    t.string   "ip"
    t.string   "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_user_sessions_on_session_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_sessions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "username",               default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_admin",               default: false, null: false
    t.boolean  "approved",               default: false, null: false
    t.index ["approved"], name: "index_users_on_approved", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
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
