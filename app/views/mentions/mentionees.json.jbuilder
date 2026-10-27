json.mentionees Array(@mentionees).filter_map { |mentionee|
  mentionee_json(mentionee)
}
