// @-mention autocomplete for Trix discussion editors.
(function () {
  function bindTrixMentions(trix) {
    if (!trix || !trix.dataset || !trix.dataset.mentionsPath) return;

    window.TrixAutocompletePicker.attach(trix, {
      stateKey: 'mentionsBound',
      pathDataKey: 'mentionsPath',
      trigger: '@',
      width: 260,
      resultKey: 'mentionees',
      attachmentType: 'Mention',
      prefix: '@',
      renderItem: function (item, escape) {
        var avatar = item.avatar_url
          ? '<img src="' + escape(item.avatar_url) + '" width="20" height="20" class="trix-ac-avatar" alt="">'
          : '';
        var ns = item.namespace
          ? '<span class="trix-ac-meta">@' + escape(item.namespace) + '</span>'
          : '';
        return avatar + '<span class="trix-ac-main"><strong>' + escape(item.name) + '</strong>' + ns + '</span>';
      }
    });
  }

  if (!window.__trixMentionsListenerBound) {
    document.addEventListener('trix-initialize', function (event) {
      bindTrixMentions(event.target);
    });
    window.__trixMentionsListenerBound = true;
  }

  $(document).on('turbolinks:load', function () {
    $('trix-editor[data-mentions-path]').each(function () {
      bindTrixMentions(this);
    });
  });
})();
