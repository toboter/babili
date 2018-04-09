module Aggregation::Event::LidoExtraction 
  extend ActiveSupport::Concern

  included do
  end

  def is_xml?(data, schema)
    data.extend(Hashie::Extensions::DeepLocate)
    data.deep_locate( -> (key, value, object) { key == 'name' && value == 'schemaLocation' }).first['content'].include?(schema)
  end

  def extract_lido(data, primary_id_label)
    data = { 
      identifier: identifier(data, primary_id_label),
      payload: {
        object_published_id: object_published_id(data),
        classification: object_classification(data),
        identification: object_identification(data),
        events: object_events(data),
        relations: 'tbd', # object_relations(data),
        rights: 'tbd',
        record: 'tbd',
        resources: 'tbd'
      }
    }
#     raise data.inspect
    return data
  end

  # value, type, label
  def identifier(data, primary_id_label)
    identifier = locate_first_by_name(primary_id_label, data)
    id = {
      value: identifier['children'].try(:first).try(:[], 'content'),
      type: locate_first_by_name('source', identifier).try(:[], 'content'),
      source: identifier['children'].first.try(:[], 'content').split('/').first,
      label: primary_id_label
    }
    return id
  end

  def object_published_id(data)
    locate_first_by_name('objectPublishedID', data)['children'].try(:first).try(:[], 'content')
  end

# ------
# ------

  def object_classification(data)
    wrap = locate_first_by_name('objectClassificationWrap', data)
    classification = {
      work_types: work_classification_types(wrap),
      classifications: classifications(data)
    }
  end

  def work_classification_types(data)
    types = []
    locate_by_name('objectWorkType', data).each do |work_type|
      types << {
        term: locate_first_by_name('term', work_type)['children'].try(:first).try(:[], 'content'),
        type: locate_first_by_name('pref', work_type).try(:[], 'content'),
        concept_id: locate_first_by_name('conceptID', work_type).try(:[], 'content')
      }
    end
    return types
  end

  def classifications(data)
    types = []
    locate_by_name('classification', data).each do |work_type|
      types << {
        term: locate_first_by_name('term', work_type)['children'].try(:first).try(:[], 'content'),
        type: locate_first_by_name('pref', work_type).try(:[], 'content'),
        concept_id: locate_first_by_name('conceptID', work_type).try(:[], 'content')
      }
    end
    return types
  end

# ------
# ------

  def object_identification(data)
    wrap = locate_first_by_name('objectIdentificationWrap', data)
    ident = {
      title: titles(wrap),
      inscriptions: '',
      repository: cust_repository(wrap),
      display_state: '',
      description: object_description(wrap),
      measurements: measurements(wrap)
    }
  end

  def titles(data)
    wrap = locate_first_by_name('titleWrap', data)
    titles = []
    locate_by_name('titleSet', wrap).each do |title_set|
      titles << { 
        value: title_set['children'].first['children'].first['content'], 
        label: title_set['attributes'].first['content'],
        type: title_set['children'].first['attributes'].first['content'],
        lang: ''
      }
    end
    return titles
  end

  def cust_repository(json)
    wrap = locate_first_by_name('repositoryWrap', json)
    repositories = []
    locate_by_name('repositorySet', wrap).each do |repository|
      work_id_wrap = locate_first_by_name('workID', repository)
      name_wrap = locate_first_by_name('repositoryName', repository)
      loc_wrap = locate_first_by_name('repositoryLocation', repository)
      repositories << {
        type: locate_first_by_name('type', repository).try(:[], 'content'),
        work_id: {
          value: work_id_wrap['children'].try(:first).try(:[], 'content'),
          type: locate_first_by_name('type', work_id_wrap).try(:[], 'content'),
          label: locate_first_by_name('label', work_id_wrap).try(:[], 'content')
        },
        legal_body: {
          identifiers: repo_body_ids(name_wrap),
          name: locate_first_by_name('appellationValue', name_wrap)['children'].try(:first).try(:[], 'content'),
          url: locate_first_by_name('legalBodyWeblink', name_wrap)['children'].try(:first).try(:[], 'content')
        },
        location: repo_location(loc_wrap)
      }
    end
    return repositories
  end

  def repo_body_ids(data)
    ids=[]
    locate_by_name('legalBodyID', data).each do |id|
    ids << {
        value: id['children'].try(:first).try(:[], 'content'),
        type: locate_first_by_name('type', id).try(:[], 'content'),
        source: locate_first_by_name('source', id).try(:[], 'content')
      }
    end
    return ids
  end

  def repo_location(data)
    level=data['children'].map{|h| h if h['name'].in?(['placeID', 'namePlaceSet'])}
    loc = {
      political: data['attributes'].try(:first).try(:[], 'content'),
      name: locate_first_by_name('appellationValue', level)['children'].try(:first).try(:[], 'content'),
      identifiers: repo_location_identifiers(level),
      part_of: data['children'].map{|p| p if p['name'].in?('partOfPlace')}.compact.empty? ? nil : repo_location(data['children'].map{|p| p if p['name'].in?('partOfPlace')}.compact.first)
    }
    return loc
  end

  def repo_location_identifiers(data)
    ids=[]
    locate_by_name('placeID', data).each do |id|
    ids << {
        value: id['children'].try(:first).try(:[], 'content'),
        type: locate_first_by_name('type', id).try(:[], 'content'),
        source: locate_first_by_name('source', id).try(:[], 'content')
      }
    end
    return ids
  end

  def object_description(data)
    wrap = locate_first_by_name('objectDescriptionWrap', data)
    descs = []
    locate_by_name('objectDescriptionSet', wrap).each do |desc|
      descs << {
        label: locate_first_by_name('type', desc).try(:[], 'content'),
        content: locate_first_by_name('descriptiveNoteValue', desc)['children'].try(:first).try(:[], 'content'),
        lang: ''
      }
    end
    return descs
  end

  def measurements(data)
    wrap = locate_first_by_name('objectMeasurementsWrap', data)
    measures = []
    locate_by_name('objectMeasurementsSet', wrap).each do |measure|
      measures << {
        display: locate_first_by_name('displayObjectMeasurements', measure)['children'].try(:first).try(:[], 'content'),
        details: {
          type: locate_first_by_name('measurementType', measure)['children'].try(:first).try(:[], 'content'),
          unit: locate_first_by_name('measurementUnit', measure)['children'].try(:first).try(:[], 'content'),
          value: locate_first_by_name('measurementValue', measure)['children'].try(:first).try(:[], 'content')
        }
      }
    end
    return measures
  end
  
# ------
# ------

  def object_events(data)
    wrap = locate_first_by_name('eventWrap', data)
    events = []
    locate_by_name('eventSet', data).each do |event|
      type_wrap = locate_first_by_name('eventType', event)
      date_wrap = locate_first_by_name('eventDate', event)
      events << {
        display: locate_first_by_name('displayEvent', event)['children'].try(:first).try(:[], 'content'),
        type: {
          term: locate_first_by_name('term', type_wrap)['children'].try(:first).try(:[], 'content'),
          lang: locate_first_by_name('lang', type_wrap).try(:[], 'content'),
          concept_id: locate_first_by_name('conceptID', type_wrap)['children'].try(:first).try(:[], 'content'),
          type: locate_first_by_name('type', type_wrap).try(:[], 'content'),
          source: locate_first_by_name('source', type_wrap).try(:[], 'content')
        },
        date: {
          display: locate_first_by_name('displayDate', date_wrap)['children'].try(:first).try(:[], 'content'),
          earliest: locate_first_by_name('earliestDate', date_wrap)['children'].try(:first).try(:[], 'content'),
          latest: locate_first_by_name('latestDate', date_wrap)['children'].try(:first).try(:[], 'content')
        },
        places: event_places(locate_by_name('eventPlace', wrap)),
        materials: event_materials(locate_by_name('eventMaterialsTech', wrap))
      }
    end
    return events
  end

  def event_places(event_places)
    places = []
    event_places.each do |place|
      places << {
        display: locate_first_by_name('displayPlace', place).try(:[], 'children').try(:first).try(:[], 'content'),
        names: locate_first_by_name('appellationValue', place).try(:[], 'children').try(:first).try(:[], 'content'),
      }
    end
    return places
  end

  def event_materials(event_materials)
    materials = []
    event_materials.each do |mat|
      materials << {
        display: locate_first_by_name('displayMaterialsTech', mat).try(:[], 'children').try(:first).try(:[], 'content'),
      }
    end
    return materials
  end

# ------
# ------

  def object_relations(data)
    locate_first_by_name('objectRelationWrap', data)
  end

  def object_rights(data) #object rights
    locate_first_by_name('rightsWorkWrap', data)
  end

  def object_record(data) #rights -> metadata rights
    locate_first_by_name('recordWrap', data)
  end

  def object_resources(data)
    locate_first_by_name('resourceWrap', data)
  end

  def locate_first_by_name(term, data)
    locate_by_name(term, data).first
  end

  def locate_by_name(term, data)
    data.extend(Hashie::Extensions::DeepLocate)
    data.deep_locate( -> (key, value, object) { key == 'name' && value == term })
  end

end