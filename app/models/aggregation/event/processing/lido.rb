module Lido

  def original_id
    data.extend(Hashie::Extensions::DeepLocate)
    work_id_wrap = data.deep_locate( -> (key, value, object) { key == 'name' && value == 'workID' }).first
    { id: work_id_wrap['children'].first['content'] }.merge(work_id_wrap['attributes'].map{|w| {w['name'].to_sym => w['content']} }.reduce({}, :merge))
  end

  def lido_rec_id
    data.extend(Hashie::Extensions::DeepLocate)
    data.deep_locate( -> (key, value, object) { key == 'name' && value == 'lidoRecID' }).first['children'].first['content']
  end

  def object_published_id
    data.extend(Hashie::Extensions::DeepLocate)
    data.deep_locate( -> (key, value, object) { key == 'name' && value == 'objectPublishedID' }).first['children'].first['content']
  end

  def titles
    titles = []
    data.extend(Hashie::Extensions::DeepLocate)
    title_wrap = data.deep_locate( -> (key, value, object) { key == 'name' && value == 'titleWrap' }).first
    title_wrap.extend(Hashie::Extensions::DeepLocate)
    title_wrap.deep_locate( -> (key, value, object) { key == 'name' && value == 'titleSet' }).each do |title_set|
      titles << { 
        appellation: title_set['children'].first['children'].first['content'], 
        label: title_set['attributes'].first['content'],
        type: title_set['children'].first['attributes'].first['content']
      }
    end
    return titles
  end
  
end