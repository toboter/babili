class Aggregation::Event::UploadEventsController < Aggregation::EventsController
  def new
  end

  def create
    @upload_event.creator = current_person
    respond_to do |format|
      if @upload_event.save
        if resource_params[:files]
          resource_params[:files].each { |f|
            @upload_event.uploads.create(file: f)
          }
        end
        format.html { redirect_to [@namespace, @repository, @upload_event], notice: 'Your data has been uploaded.' }
        format.json { render :show, status: :created, location: @upload_event }
      else
        format.html { render :new }
        format.json { render json: @upload_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @upload_event.update(resource_params)
        format.html { redirect_to [@namespace, @repository], notice: "Upload was successfully updated." }
        format.json { render :show, status: :ok, location: @upload_event }
      else
        format.html { render :edit }
        format.json { render json: @upload_event.errors, status: :unprocessable_entity }
      end
    end
  end

end