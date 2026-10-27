require "test_helper"

class Api::JsonContractTest < ActionDispatch::IntegrationTest
  API_HOST = "api.example.com"

  setup do
    host! API_HOST
    Rails.application.routes.default_url_options = { host: "www.example.com" }
    ActionMailer::Base.default_url_options = { host: "www.example.com" }
    ActionMailer::Base.deliveries.clear


    @user = User.new(
      email: "contract-user-#{SecureRandom.hex(4)}@example.com",
      password: "password123",
      password_confirmation: "password123",
      slug: "cu#{SecureRandom.hex(4)}",
      approved: true,
      confirmed_at: Time.current
    )
    @user.define_singleton_method(:send_admin_mail) { true }
    @user.skip_confirmation_notification! if @user.respond_to?(:skip_confirmation_notification!)
    @user.save!
    @user.update_columns(approved: true, confirmed_at: Time.current)

    @oauth_app = Doorkeeper::Application.create!(
      name: "Contract App #{SecureRandom.hex(4)}",
      uid: "contract-client-uid-#{SecureRandom.hex(8)}",
      secret: SecureRandom.hex(16),
      redirect_uri: "https://example.com/callback",
      scopes: "public",
      owner: @user
    )
    @token = Doorkeeper::AccessToken.create!(
      application: @oauth_app,
      resource_owner_id: @user.id,
      scopes: "public"
    )
  end

  def auth_headers
    { "Authorization" => "Bearer #{@token.token}", "Accept" => "application/json" }
  end

  def json_body
    JSON.parse(response.body)
  end

  test "GET /v1/user wraps user root with key fields" do
    get "/v1/user", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("user"), "expected user root, got keys: #{body.keys}"
    user = body["user"]
    assert_equal @user.id, user["id"]
    assert_equal @user.person.namespace.name, user["username"]
    assert_equal @user.email, user["email"]
    assert user.key?("display_name")
    assert user.key?("image_thumb_50")
  end

  test "GET /v1/authorizations/clients/:uid wraps application_authorization_client" do
    get "/v1/authorizations/clients/#{@oauth_app.uid}", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("application_authorization_client"), "expected application_authorization_client root, got: #{body.keys}"
    client = body["application_authorization_client"]
    assert_equal @oauth_app.id, client["id"]
    assert client.key?("token")
    assert client.key?("user_permissions")
    assert client.dig("user_permissions", "extra")
    assert client.key?("app")
    assert_equal @oauth_app.uid, client["app"]["client_id"]
    assert client.key?("organization_accessors")
    assert client.key?("person_accessors")
  end

  test "GET /v1/collections wraps collections with user_access_token" do
    collection = Oread::Application.new(
      name: "Contract Collection #{SecureRandom.hex(4)}",
      uid: SecureRandom.hex(16),
      host: "https://collection.example.com",
      port: 443,
      owner: @user
    )
    collection.save!(validate: false)
    collection.collection_classes.create!(repo_api_url: "https://collection.example.com/api")
    oread_token = "oread-token-#{SecureRandom.hex(4)}"
    Oread::AccessToken.create!(
      application: collection,
      resource_owner: @user,
      token: oread_token
    )

    get "/v1/collections", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("collections"), "expected collections root, got: #{body.keys}"
    found = body["collections"].find { |c| c["id"] == collection.id }
    assert found, "expected collection in payload"
    assert_equal collection.uid, found["uid"]
    assert_equal oread_token, found["user_access_token"]
  end

  test "GET /v1/user/repositories wraps collections root" do
    collection = Oread::Application.new(
      name: "Enrolled Collection #{SecureRandom.hex(4)}",
      uid: SecureRandom.hex(16),
      host: "https://enrolled.example.com",
      port: 443,
      owner: @user
    )
    collection.save!(validate: false)
    collection.collection_classes.create!(repo_api_url: "https://enrolled.example.com/api")
    Oread::AccessEnrollment.create!(
      application: collection,
      enrollee: @user,
      creator: @user
    )

    get "/v1/user/repositories", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("collections"), "expected collections root, got: #{body.keys}"
  end

  test "GET vocab concept wraps concept root" do
    namespace = @user.person.namespace
    scheme = Vocab::Scheme.create!(
      title: "Contract Scheme",
      abbr: "cs#{SecureRandom.hex(2)}",
      slug: "contract-scheme-#{SecureRandom.hex(4)}",
      namespace: namespace,
      creator: @user.person,
      definition: "def"
    )
    concept = Vocab::Concept.new(
      scheme: scheme,
      creator: @user.person,
      slug: "concept-#{SecureRandom.hex(4)}",
      status: "published",
      uuid: SecureRandom.uuid,
      type: "Concept"
    )
    concept.labels.build(
      type: "Preferred",
      body: "Contract Label",
      language: "eng (en) - English",
      vernacular: "Undetermined",
      historical: "Current",
      creator: @user.person,
      is_abbrevation: false
    )
    concept.save!

    get "/v1/#{namespace.name}/vocab/schemes/#{scheme.slug}/concepts/#{concept.slug}", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("concept"), "expected concept root, got: #{body.keys}"
    assert body["concept"].key?("id")
    assert body["concept"].key?("links")
  end

  test "GET bibliography entry wraps citation_data_item root" do
    entry = Biblio::Misc.create!(
      title: "Contract Misc",
      year: "2020",
      slug: "contract-misc-#{SecureRandom.hex(4)}",
      creator: @user.person,
      citation_raw: "Contract #{SecureRandom.hex(3)}"
    )

    get "/v1/bibliography/miscs/#{entry.to_param}", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("citation_data_item"), "expected citation_data_item root, got: #{body.keys}"
    item = body["citation_data_item"]
    assert_equal "article", item["type"]
    assert_equal entry.slug, item["id"]
    assert item.key?("title")
    assert item.key?("schema")
    assert item.key?("links")
  end

  test "GET bibliography entries index wraps citation_data_items root" do
    book = Biblio::Misc.create!(
      title: "Indexed Misc",
      year: "2019",
      slug: "indexed-misc-#{SecureRandom.hex(4)}",
      creator: @user.person,
      citation_raw: "Indexed #{SecureRandom.hex(3)}"
    )

    results = [book]
    # Searchkick-style stub for Pagy passive mode (pagy(:searchkick, results))
    def results.options; { page: 1, per_page: 50 }; end
    def results.total_count; size; end

    singleton = Biblio::Entry.singleton_class
    singleton.alias_method :__contract_search_orig, :search
    singleton.define_method(:search) { |*_a, **_k| results }
    begin
      get "/v1/bibliography/entries", headers: auth_headers
    ensure
      singleton.alias_method :search, :__contract_search_orig
      singleton.remove_method :__contract_search_orig
    end
    assert_response :success
    body = json_body
    assert body.key?("citation_data_items"), "expected citation_data_items root, got: #{body.keys}"
    assert body.key?("meta")
  end

  test "GET raw file upload wraps file root" do
    upload = Raw::Image.new(
      slug: "file-#{SecureRandom.hex(4)}",
      uploader: @user.person,
      file_signature: SecureRandom.hex(8),
      file_data: {
        "original" => {
          "id" => "test-id",
          "storage" => "store",
          "metadata" => { "filename" => "x.png", "size" => 1, "mime_type" => "image/png" }
        }
      }.to_json
    )
    upload.save!(validate: false)

    get "/v1/raw/files/#{upload.slug}", headers: auth_headers
    assert_response :success
    body = json_body
    assert body.key?("file"), "expected file root, got: #{body.keys}"
    file = body["file"]
    assert_equal upload.slug, file["id"]
    assert file.key?("gid")
    assert file.key?("file_url")
    assert file.key?("html_url")
  end
end
