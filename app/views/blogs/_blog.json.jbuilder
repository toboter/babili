json.extract! blog, :id, :type, :author, :title, :content, :external_link, :posted_at, :images, :created_at, :updated_at
json.url blog_url(blog, format: :json)