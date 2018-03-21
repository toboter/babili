class Aggregation::Event::ListTransformsController < Aggregation::EventsController
  def new
    raise @file_upload.inspect
  end

  def create
    @file_upload.creator = current_person
  end

end