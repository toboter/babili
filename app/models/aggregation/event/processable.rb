module Processable

  include Processing::Lido
  
  def parse_xml_file
    doc = Nokogiri::XML(File.open(self.file.download.path))
    json = JSON.parse(JSON.generate(doc.root))
    item = Aggregation::Item.joins(:identifiers)
        .where(identifiers: { origin_id: event.processor.primary_id_label } )
        .first_or_create(repository_id: event.repository_id)
    Aggregation::Commit.create(item_id: item, event_id: self, creator_id: self.creator_id, data: json)
  end
  
end