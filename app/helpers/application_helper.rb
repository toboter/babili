module ApplicationHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end
  def subline(page_subline)
    content_for(:subline) { h(page_subline.to_s) }
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

end
