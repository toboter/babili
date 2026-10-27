// #-reference autocomplete for Trix discussion editors.
(function () {
  function bindTrixReferences(trix) {
    if (!trix || !trix.dataset || !trix.dataset.referencesPath) return;

    window.TrixAutocompletePicker.attach(trix, {
      stateKey: 'referencesBound',
      pathDataKey: 'referencesPath',
      trigger: '#',
      width: 340,
      resultKey: 'referenceables',
      attachmentType: 'Reference',
      prefix: '#',
      renderItem: function (item, escape) {
        var parents = item.parents
          ? '<div class="trix-ac-meta">' + escape(item.parents) + '</div>'
          : '';
        var note = item.note
          ? '<div class="trix-ac-note">' + escape(item.note) + '</div>'
          : '';
        return '<div class="trix-ac-main"><strong>' + escape(item.name) + '</strong></div>' + parents + note;
      }
    });
  }

  if (!window.__trixReferencesListenerBound) {
    document.addEventListener('trix-initialize', function (event) {
      bindTrixReferences(event.target);
    });
    window.__trixReferencesListenerBound = true;
  }

  $(document).on('turbolinks:load', function () {
    $('trix-editor[data-references-path]').each(function () {
      bindTrixReferences(this);
    });
  });
})();
