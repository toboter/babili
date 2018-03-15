class Aggregation::Commit::ProcessTabularJob < ApplicationJob
  queue_as :default

  def perform(id)
    event = Aggregation::Event.find(id)
    spreadsheet = event.open_spreadsheet
    header = spreadsheet.row(1).map{|h| h.underscore }
    commits = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      item = Aggregation::Item.joins(:identifiers)
        .where(identifiers: { origin_id: row[event.processor.primary_id_label]} )
        .first_or_create(repository_id: event.repository_id)
      commits << Aggregation::Commit.new(item_id: item, event_id: event, creator_id: event.creator_id, data: row)
    end
    Aggregation::Commit.import(commits)
  end

end