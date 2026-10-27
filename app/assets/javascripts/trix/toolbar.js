(function () {
  document.addEventListener('trix-initialize', function (event) {
    var editorElement = event.target;
    if (editorElement.dataset.toolbarExtrasBound === 'true') return;
    editorElement.dataset.toolbarExtrasBound = 'true';

    var toolbarElement = $(editorElement.toolbarElement);
    if (!toolbarElement.length) return;

    var group = toolbarElement.find('span.trix-button-group.trix-button-group--block-tools');
    if (!group.length) return;

    var attachButton = $(
      '<button type="button" class="trix-button trix-button--icon trix-button--icon-attach" data-trix-action="x-attach" title="Attach Files">Attach Files</button>'
    );
    var mentionButton = $(
      '<button type="button" class="trix-button trix-button--icon trix-button--icon-mention" data-trix-action="mention" title="Mention someone">Mention someone</button>'
    );
    var refButton = $(
      '<button type="button" class="trix-button trix-button--icon trix-button--icon-reference" data-trix-action="reference" title="Reference something">Reference something</button>'
    );
    group.append(attachButton).append(mentionButton).append(refButton);

    var fileInput = $('<input type="file" multiple>').on('change', function () {
      var files = this.files || [];
      for (var i = 0; i < files.length; i++) {
        editorElement.editor.insertFile(files[i]);
      }
    });

    attachButton.on('click', function (event) {
      event.preventDefault();
      fileInput.click();
    });

    // Insert bare trigger (no trailing space) so autocomplete can detect it.
    mentionButton.on('click', function (event) {
      event.preventDefault();
      editorElement.editor.insertString('@');
      editorElement.focus();
    });

    refButton.on('click', function (event) {
      event.preventDefault();
      editorElement.editor.insertString('#');
      editorElement.focus();
    });
  });
})();
