json.extract! project, :id, :name, :image_data, :description, :created_at, :updated_at
json.url project_url(project, format: :json)