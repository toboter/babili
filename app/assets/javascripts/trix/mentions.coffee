# https://anotherengineeringblog.com/twitter-mention-feature-for-rails
# https://github.com/ichord/At.js/wiki
# https://gist.github.com/lawso017/44df47968be36222b874b8c4d94b779b
# https://github.com/ichord/At.js/issues/470

# At a high level, we listen for trix-change, use editor.getPosition() and editor.getDocument().toString() 
# to determine what character was typed, and position the autocomplete options using 
# editor.getClientRectAtPosition().

$ ->
  document.addEventListener "trix-initialize", (event) =>
    TrixMentions.prepare($(event.target))

  class TrixMentions
    MENTIONS_PATH = "mentions-path"
    MENTIONS_DIV_ID = "#trix-mentions-"
    MENTIONS_INPUT_ID = MENTIONS_DIV_ID + "input-"

    @prepare: ($trix) ->
      mentionsDivForTrix = ($trix) ->
        $(MENTIONS_DIV_ID + $trix.attr('trix-id'))

      mentionsInputForTrix = ($trix) ->
        $(MENTIONS_INPUT_ID + $trix.attr('trix-id'))

      mentionsSelectizeForTrix = ($trix) ->
        mentionsInputForTrix($trix).next('.selectize-control')

      mentionsSelectizeDropdownForTrix = ($trix) ->
        mentionsInputForTrix($trix).next('.selectize-dropdown')

      createMentionsDivForTrix = ($trix) ->
        $trix.after("<trix-mentions id='trix-mentions-"+  $trix.attr('trix-id') + "'><input id='trix-mentions-input-" + $trix.attr('trix-id') + "'></input></trix-mentions>")

      initializeMentionsSelectize = ($trix) ->
        mentionsInputForTrix($trix).selectize
          valueField: 'gid'
          labelField: 'name'
          searchField: ['name', 'namespace']
          sortField: 'name'
          options: []
          selectOnTab: true
          load: (query, callback) ->
            if !query.length
              callback()
            $.ajax
              url: $trix.data(MENTIONS_PATH)
              data: {q: query}
              dataType: 'json'
              type: 'GET'
              error: (result) ->
                callback()
              success: (result) ->
                callback result['mentionees']
          onInitialize: ->
            @.disable()
            mentionsSelectizeForTrix($trix).css('left', -1000)
          onItemAdd: (value, $item) ->
            embed = "<span class='mention'>@" + $item.text() + "</span>"
            attachment = new Trix.Attachment
              content: embed
              'type': 'Mention'
              'gid': $item.data('value')
            $trix[0].editor.setSelectedRange([$trix.data('last-position') - 1, $trix.data('last-position')])
            $trix[0].editor.deleteInDirection('forward')
            $trix[0].editor.insertAttachment attachment
            mentionsDivForTrix($trix).hide()
          onBlur: ->
            mentionsDivForTrix($trix).hide()
            @.disable()
            mentionsSelectizeForTrix($trix).css('left', -1000)
            $trix.focus()
            if @.items.length == 0
              $trix[0].editor.setSelectedRange([$trix.data('last-position') - 1, $trix.data('last-position')])
              $trix[0].editor.deleteInDirection('forward')
          onDropdownClose: ->
            mentionsDivForTrix($trix).hide()
          onDropdownOpen: ($dropdown) ->
            rect = $trix[0].editor.getClientRectAtPosition($trix[0].editor.getPosition())
            if rect != undefined
              $dropdown.css('top', 34)
              if rect.left + 200 > $trix.offset().left + $trix.width()
                $dropdown.css('left', $trix.offset().left + $trix.width() - (rect.left + 210))
          onType: (str) ->
            rect = $trix[0].editor.getClientRectAtPosition($trix[0].editor.getPosition())
            if rect.left + 200 > $trix.offset().left + $trix.width()
              mentionsSelectizeDropdownForTrix($trix).css('left', $trix.offset().left + $trix.width() - (rect.left + 210))

      openMentionsSelectize = ($trix, editor) ->
        $trix.data 'last-position', editor.getPosition()

        mentionsInput = mentionsInputForTrix($trix)
        mentionsSelectize = mentionsSelectizeForTrix($trix)
        rect = editor.getClientRectAtPosition(editor.getPosition())

        mentionsSelectize.css('left', rect.left - 10)
        mentionsSelectize.css('top', rect.top - 7)
        mentionsInput[0].selectize.clear()
        mentionsInput[0].selectize.enable()
        mentionsDivForTrix($trix).show()
        mentionsInput[0].selectize.focus()

      if $trix.data(MENTIONS_PATH).length > 0
        $trix.on 'trix-change', ->
          editor = @.editor
          char = editor.getDocument().toString().charAt(editor.getPosition() - 1)
          createMentionsDivForTrix($trix)
          initializeMentionsSelectize($trix)
          openMentionsSelectize($(@), editor) if char == '@'