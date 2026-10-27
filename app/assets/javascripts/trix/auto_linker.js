// https://github.com/basecamp/trix/issues/167
// https://gist.github.com/javan/7b0c99f43e67080c2380e8d30707f773
(function () {
  var INPUT = document.createElement('input');
  INPUT.type = 'url';
  INPUT.required = true;

  function isValidURL(value) {
    INPUT.value = value;
    return INPUT.checkValidity();
  }

  function TrixAutoLinker(element) {
    this.element = element;
    this.editor = element.editor;
    this.autoLink = this.autoLink.bind(this);
    this.element.addEventListener('trix-render', this.autoLink);
    this.autoLink();
  }

  TrixAutoLinker.prototype.getDocument = function () {
    return this.editor.getDocument();
  };

  TrixAutoLinker.prototype.getDocumentString = function () {
    return this.getDocument().toString();
  };

  TrixAutoLinker.prototype.getHrefAtRange = function (range) {
    return this.getDocument().getCommonAttributesAtRange(range).href;
  };

  TrixAutoLinker.prototype.getURLsWithRanges = function () {
    var results = [];
    var string = this.getDocumentString();
    var pattern = /(https?:\/\/\S+\.\S+)\s/gi;
    var match;
    while ((match = pattern.exec(string))) {
      var url = match[1];
      if (isValidURL(url)) {
        var position = match.index;
        results.push({ url: url, range: [position, position + url.length] });
      }
    }
    return results;
  };

  TrixAutoLinker.prototype.autoLink = function () {
    var urls = this.getURLsWithRanges();
    for (var i = 0; i < urls.length; i++) {
      var url = urls[i].url;
      var range = urls[i].range;
      if (this.getHrefAtRange(range) !== url) {
        var currentRange = this.editor.getSelectedRange();
        this.editor.setSelectedRange(range);
        if (this.editor.canActivateAttribute('href')) {
          this.editor.activateAttribute('href', url);
        }
        this.editor.setSelectedRange(currentRange);
      }
    }
  };

  function bindAutoLinker(trix) {
    if (!trix || trix.dataset.autoLinkerBound === 'true') return;
    trix.dataset.autoLinkerBound = 'true';
    new TrixAutoLinker(trix);
  }

  if (!window.__trixAutoLinkerListenerBound) {
    document.addEventListener('trix-initialize', function (event) {
      bindAutoLinker(event.target);
    });
    window.__trixAutoLinkerListenerBound = true;
  }

  $(document).on('turbolinks:load', function () {
    $('trix-editor').each(function () {
      bindAutoLinker(this);
    });
  });
})();
