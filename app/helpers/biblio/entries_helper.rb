module Biblio::EntriesHelper
  # Returns a dynamic path based on the provided parameters
  def sti_entry_path(type = "entry", entry = nil, action = nil)
  	send "#{type.split("::").first.downcase}_#{format_sti(action, type.demodulize, entry)}_path", entry
  end
 
  def format_sti(action, type, entry)
    action || entry ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end
 
  def format_action(action)
    action ? "#{action}_" : ""
  end
end