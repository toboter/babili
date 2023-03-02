module ApplicationHelper
  def plain_first_paragraph(html_content)
    paragraph = Nokogiri::HTML.parse(html_content).css('p')&.first&.children&.first&.text
    paragraph = paragraph.split(/\D[\.\!\?\:]\s|\n/).first if paragraph.present?
    paragraph ? "#{paragraph}#{'.' unless paragraph.lstrip.match?(/[\.\!\?\:]/)}" : nil
  end

  def commentify(content)
    pipeline_context = { whitelist: Sanitize::Config::RELAXED }
    pipeline = HTML::Pipeline.new [
      # HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter
    ], pipeline_context
    pipeline.call(content)[:output].to_s.html_safe
  end

  def documentify(content)
    pipeline_context = { whitelist: Sanitize::Config::RELAXED }
    pipeline = HTML::Pipeline.new [
      # HTML::Pipeline::MarkdownFilter,
      HTML::Pipeline::SanitizationFilter
    ], pipeline_context
    pipeline.call(content)[:output].to_s.html_safe
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: false, with_toc_data: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true,
      footnotes: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def teaser(text)
    renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true, no_images: true, no_links: true)
    options = {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end

  def toc(text)
    Redcarpet::Render::HTML_TOC
    renderer = Redcarpet::Render::HTML_TOC.new
    options = {
      escape_html: true
    }
    Redcarpet::Markdown.new(renderer, options).render(text).html_safe
  end


  def background_image_div obj, size, options={}
    style = options.delete(:style) { |el| "" }
    klass = options.delete(:class) { |el| "" }
    content_tag :div, '', style: "background-image: #{background_image_url obj, size};background-repeat: no-repeat;background-size: cover;#{style}", class: "#{klass}"
  end

  def background_image_url obj, size
    if obj.image.present? && size != 'false'
      "url(#{obj.image_url(size)})"
    else
      pattern = GeoPattern.generate(obj.name.presence || 'default text')
      pattern.to_data_uri
    end
  end

end
