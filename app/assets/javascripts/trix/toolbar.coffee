$(document).on 'trix-initialize', (event) ->
  editorElement = event.target
  toolbarElement = $(editorElement.toolbarElement);

  attachButton = $("""<button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="x-attach" title="Attach Files">Attach Files</button>""")
  mentionButton = $("""<button type="button" class="trix-button trix-button--icon trix-button--icon-mention" data-trix-action="mention" title="Mention someone">Mention someone</button>""")
  toolbarElement.find('span.trix-button-group.trix-button-group--block-tools').append(attachButton).append(mentionButton)

  fileInput = $("""<input type="file" multiple>""").on 'change', ->
    for file in this.files
      editorElement.editor.insertFile(file)

  attachButton.on 'click', (event) ->
    fileInput.click()

  mentionButton.on 'click', (event) ->
    editorElement.editor.insertString('@ ')