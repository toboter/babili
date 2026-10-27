json.journals @journals do |journal|
  json.merge! biblio_journal_json(journal)
end
