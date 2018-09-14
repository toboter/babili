# https://github.com/basecamp/trix/issues/167
# https://gist.github.com/javan/7b0c99f43e67080c2380e8d30707f773

$(document).on 'turbolinks:load', ->
  addEventListener "trix-initialize", (event) ->
    new TrixAutoLinker event.target

  class TrixAutoLinker
    constructor: (@element) ->
      {@editor} = @element
      @element.addEventListener("trix-render", @autoLink)
      @autoLink()

    autoLink: =>
      for {url, range} in @getURLsWithRanges()
        unless @getHrefAtRange(range) is url
          currentRange = @editor.getSelectedRange()
          @editor.setSelectedRange(range)
          if @editor.canActivateAttribute("href")
            @editor.activateAttribute("href", url)
          @editor.setSelectedRange(currentRange)

    getDocument: ->
      @editor.getDocument()

    getDocumentString: ->
      @getDocument().toString()

    getHrefAtRange: (range) ->
      @getDocument().getCommonAttributesAtRange(range).href

    PATTERN = ///(https?://\S+\.\S+)\s///ig

    getURLsWithRanges: ->
      results = []
      string = @getDocumentString()
      while match = PATTERN.exec(string)
        url = match[1]
        if isValidURL(url)
          position = match.index
          range = [position, position + url.length]
          results.push({url, range})
      results

    INPUT = document.createElement("input")
    INPUT.type = "url"
    INPUT.required = true

    isValidURL = (value) ->
      INPUT.value = value
      INPUT.checkValidity()