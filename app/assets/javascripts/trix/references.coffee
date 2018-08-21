# https://anotherengineeringblog.com/twitter-mention-feature-for-rails
# https://github.com/ichord/At.js/wiki
# https://gist.github.com/lawso017/44df47968be36222b874b8c4d94b779b
# https://github.com/ichord/At.js/issues/470

# At a high level, we listen for trix-change, use editor.getPosition() and editor.getDocument().toString() 
# to determine what character was typed, and position the autocomplete options using 
# editor.getClientRectAtPosition().

$ ->
  document.addEventListener "trix-initialize", (event) =>
    TrixRefs.prepare($(event.target))

  class TrixRefs
    REFS_PATH = "references-path"
    REFS_DIV_ID = "#trix-references-"
    REFS_INPUT_ID = REFS_DIV_ID + "input-"

    @prepare: ($trix) ->
      refsDivForTrix = ($trix) ->
        $(REFS_DIV_ID + $trix.attr('trix-id'))

      refsInputForTrix = ($trix) ->
        $(REFS_INPUT_ID + $trix.attr('trix-id'))

      refsSelectizeForTrix = ($trix) ->
        refsInputForTrix($trix).next('.selectize-control')

      refsSelectizeDropdownForTrix = ($trix) ->
        refsInputForTrix($trix).next('.selectize-dropdown')

      createRefsDivForTrix = ($trix) ->
        $trix.after("<trix-references id='trix-references-"+  $trix.attr('trix-id') + "'><input id='trix-references-input-" + $trix.attr('trix-id') + "'></input></trix-references>")

      initializeRefsSelectize = ($trix) ->
        refsInputForTrix($trix).selectize
          valueField: 'gid'
          labelField: 'name'
          searchField: ['name', 'labels']
          sortField: 'name'
          options: []
          selectOnTab: true
          load: (query, callback) ->
            if !query.length
              callback()
            $.ajax
              url: $trix.data(REFS_PATH)
              data: {q: query}
              dataType: 'json'
              type: 'GET'
              error: (result) ->
                callback()
              success: (result) ->
                callback result['referenceables']
          render: option: (item, escape) ->
            '<div style="padding:10px">' + '<strong>' + escape(item.name) + '</strong>' + '<p class="text-small">' + '<em>' + escape(item.parents) + '</em>' + '</p>' + '<p class="text-small">' + escape(item.note) + '</p>' + '</div>'
          onInitialize: ->
            @.disable()
            refsSelectizeForTrix($trix).css('left', -1000)
          onItemAdd: (value, $item) ->
            embed = "<span class='mention'>#" + $item.text() + "</span>"
            attachment = new Trix.Attachment
              content: embed
              'type': 'Reference'
              'gid': $item.data('value')
            $trix[0].editor.setSelectedRange([$trix.data('last-position') - 1, $trix.data('last-position')])
            $trix[0].editor.deleteInDirection('forward')
            $trix[0].editor.insertAttachment attachment
            refsDivForTrix($trix).remove()
          onBlur: ->
            refsDivForTrix($trix).remove()
            @.disable()
            refsSelectizeForTrix($trix).css('left', -1000)
            $trix.focus()
            if @.items.length == 0
              $trix[0].editor.setSelectedRange([$trix.data('last-position') - 1, $trix.data('last-position')])
              $trix[0].editor.deleteInDirection('forward')
          onDropdownClose: ->
            refsDivForTrix($trix).remove()
          onDropdownOpen: ($dropdown) ->
            rect = $trix[0].editor.getClientRectAtPosition($trix[0].editor.getPosition())
            if rect != undefined
              $dropdown.css('top', 34)
              if rect.left + 200 > $trix.offset().left + $trix.width()
                $dropdown.css('left', $trix.offset().left + $trix.width() - (rect.left + 210))
          onType: (str) ->
            rect = $trix[0].editor.getClientRectAtPosition($trix[0].editor.getPosition())
            if rect.left + 200 > $trix.offset().left + $trix.width()
              refsSelectizeDropdownForTrix($trix).css('left', $trix.offset().left + $trix.width() - (rect.left + 210))

      openRefsSelectize = ($trix, editor) ->
        $trix.data 'last-position', editor.getPosition()

        refsInput = refsInputForTrix($trix)
        refsSelectize = refsSelectizeForTrix($trix)
        rect = editor.getClientRectAtPosition(editor.getPosition())

        refsSelectize.css('left', rect.left - 10)
        refsSelectize.css('top', rect.top - 7)
        refsInput[0].selectize.clear()
        refsInput[0].selectize.enable()
        refsDivForTrix($trix).show()
        refsInput[0].selectize.focus()

      if $trix.data(REFS_PATH).length > 0
        console.log $trix.data(REFS_PATH)
        $trix.on 'trix-change', ->
          editor = @.editor
          char = editor.getDocument().toString().charAt(editor.getPosition() - 1)
          createRefsDivForTrix($trix) if char == '#'
          initializeRefsSelectize($trix) if char == '#'
          openRefsSelectize($(@), editor) if char == '#'