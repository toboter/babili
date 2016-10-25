module BlogsHelper
  # Returns a dynamic path based on the provided parameters
  def sti_blog_path(type = "blog", blog = nil, action = nil, param = nil)
  	send "#{format_sti(action, type, blog)}_path", blog, param
  end

  def format_sti(action, type, blog)
    action || blog ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end
 
  def format_action(action)
    action ? "#{action}_" : ""
  end
end
