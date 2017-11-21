module CMS::BlogCategoriesHelper

  def view_page_tree_for(pages)
    html = content_tag(:ul, class: 'category-articles chevron') {
      ul_contents = ""
      pages.each do |page|
        if page.present?
          ul_contents << content_tag(:li, link_to(page.title, page, style: "margin-left:#{page.depth*10}px"), class: "help-link", id: "help-article-#{page.id}")
          if page.children.any?
            ul_contents << view_page_tree_for(page.children)
          end
        end
      end
      ul_contents.html_safe
    }.html_safe
  end

end