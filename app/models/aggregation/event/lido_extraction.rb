module Aggregation::Event::LidoExtraction 
  extend ActiveSupport::Concern

  included do
  end

  def is_xml?(data, schema)
    data.extend(Hashie::Extensions::DeepLocate)
    data.deep_locate( -> (key, value, object) { key == 'name' && value == 'schemaLocation' }).first['content'].include?(schema)
  end

  def extract_lido(data, primary_id_label)
    data.extend(Hashie::Extensions::DeepLocate)
    lido_rec_id = data.deep_locate( -> (key, value, object) { key == 'name' && value == primary_id_label }).first
    data = { 
      identifier: {
        id: lido_rec_id['children'].first['content'],
        type: lido_rec_id.extend(Hashie::Extensions::DeepLocate).deep_locate( -> (key, value, object) { key == 'name' && value == 'source' }).first['content'],
        agent: lido_rec_id['children'].first['content'].split('/').first,
        label: primary_id_label
      },
      payload: {
        work_id: work_id(data),
        object_published_id: object_published_id(data),
        titles: titles(data)
      }
    }
    return data
  end

  def work_id(data)
    data.extend(Hashie::Extensions::DeepLocate)
    work_id_wrap = data.deep_locate( -> (key, value, object) { key == 'name' && value == 'workID' }).first
    { id: work_id_wrap['children'].first['content'] }.merge(work_id_wrap['attributes'].map{|w| {w['name'].to_sym => w['content']} }.reduce({}, :merge))
  end

  # def lido_rec_id
  #   data.extend(Hashie::Extensions::DeepLocate)
  #   data.deep_locate( -> (key, value, object) { key == 'name' && value == 'lidoRecID' }).first['children'].first['content']
  # end

  def object_published_id(data)
    data.extend(Hashie::Extensions::DeepLocate)
    data.deep_locate( -> (key, value, object) { key == 'name' && value == 'objectPublishedID' }).first['children'].first['content']
  end

  def titles(data)
    titles = []
    data.extend(Hashie::Extensions::DeepLocate)
    title_wrap = data.deep_locate( -> (key, value, object) { key == 'name' && value == 'titleWrap' }).first
    title_wrap.extend(Hashie::Extensions::DeepLocate)
    title_wrap.deep_locate( -> (key, value, object) { key == 'name' && value == 'titleSet' }).each do |title_set|
      titles << { 
        value: title_set['children'].first['children'].first['content'], 
        label: title_set['attributes'].first['content'],
        type: title_set['children'].first['attributes'].first['content']
      }
    end
    return titles
  end
end