module ApplicationHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
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


  def render_image_or_pattern(image=nil, version=nil, text='default text babylon-online.org', height=200)
    if image
      image_tag version, class: 'img-responsive', style: "width: 100%;"
    else
      pattern = GeoPattern.generate(text)
      return "<div style='background-image: #{pattern.to_data_uri}; width: 100%; height: #{height}px;'></div>".html_safe
    end
  end

end
