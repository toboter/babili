# t.integer  :repository_id
# t.integer  :creator_id
# t.text     :note
# t.string   :type   # upload, api_request, list
# t.jsonb    :origin # file_data, content_type, schema(lido, table); http_request_url; list_id
# # es muss ja irgendwie sichergestellt werden dass am ende json importiert wird, 
# # vielleicht sogar nach einem zu definierende Standard. Array, weil eine Kette 
# # an zu durchlaufenden Prozessen zu erwarten ist. Bsp.: LIDO.xml to json, mapping xy.
# # saved procedures? user definded mappings?
# t.jsonb    :processors # primary_id_label || id, other_identificator_labels [], 
# t.datetime :commited_at # if present?: locked.
# t.timestamps

class Aggregation::Event < ApplicationRecord
  TYPES = %w(FileUpload ApiRequest ListTransform)

  belongs_to :repository
  belongs_to :creator, class_name: "Person"

  has_many :commits, dependent: :destroy
  has_many :items, through: :commits
  
  validates :note, :creator, :repository, presence: true


  def locked?
    commited_at.present?
  end

  
end