json.referenceables Array(@referenceables).filter_map { |referenceable|
  begin
    referenceable_json(referenceable)
  rescue StandardError
    nil
  end
}
