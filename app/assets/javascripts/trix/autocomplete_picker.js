// @ / # autocomplete for Trix.
// Keeps focus in the editor and shows a floating menu (no Selectize focus-stealing).
window.TrixAutocompletePicker = {
  // text, caretPos, triggerChar ('@' or '#') -> { triggerIndex, query } or null
  activeTrigger: function (text, caretPos, triggerChar) {
    if (text == null || caretPos <= 0) return null;

    var before = text.substring(0, caretPos);
    // \uFFFC is Trix's object-replacement char for attachments.
    var escaped = triggerChar.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
    var other = triggerChar === '#' ? '@' : '#';
    var pattern = new RegExp('(^|[\\s\\uFFFC])' + escaped + '([^\\s' + escaped + other + ']*)$');
    var match = before.match(pattern);
    if (!match) return null;

    var query = match[2] != null ? match[2] : '';
    return {
      triggerIndex: caretPos - query.length - 1,
      query: query
    };
  },

  escapeHtml: function (value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  },

  // options: trigger, pathDataKey, width, resultKey, renderItem,
  //          attachmentType, prefix, stateKey
  attach: function (trix, options) {
    var stateKey = options.stateKey;
    if (trix.dataset[stateKey] === 'true') return;
    trix.dataset[stateKey] = 'true';

    var path = trix.dataset[options.pathDataKey];
    if (!path || String(path).length === 0) return;

    var editor = trix.editor;
    var open = false;
    var items = [];
    var selectedIndex = 0;
    var triggerIndex = null;
    var lastQuery = null;
    var loadTimer = null;
    var request = null;
    var $menu = null;
    var width = options.width || 260;

    function closeMenu() {
      if (loadTimer) {
        clearTimeout(loadTimer);
        loadTimer = null;
      }
      if (request && request.abort) {
        try { request.abort(); } catch (e) { /* ignore */ }
        request = null;
      }
      if ($menu) {
        $menu.remove();
        $menu = null;
      }
      open = false;
      items = [];
      selectedIndex = 0;
      triggerIndex = null;
      lastQuery = null;
    }

    function ensureMenu() {
      if ($menu && $menu.length) return;
      $menu = $('<div class="trix-ac-menu" role="listbox"></div>').css({
        position: 'fixed',
        width: width,
        zIndex: 10000,
        display: 'none'
      });
      $menu.on('mousedown', '.trix-ac-item', function (event) {
        // Prevent Trix blur / caret jump; selection happens on mousedown.
        event.preventDefault();
        event.stopPropagation();
        pick(Number($(this).attr('data-index')));
      });
      $('body').append($menu);
    }

    function positionMenu() {
      if (!$menu) return;
      var pos = editor.getPosition();
      var rect = editor.getClientRectAtPosition(Math.max(0, pos - 1)) ||
        editor.getClientRectAtPosition(pos);
      if (!rect) {
        // Fallback near the editor if caret rect is unavailable.
        var box = trix.getBoundingClientRect();
        $menu.css({ left: box.left + 12, top: box.top + 40, display: 'block' });
        return;
      }
      var left = rect.left;
      var top = rect.bottom + 6;
      var maxRight = window.innerWidth - 12;
      if (left + width > maxRight) left = Math.max(12, maxRight - width);
      if (top + 240 > window.innerHeight) top = Math.max(12, rect.top - 6 - Math.min(240, $menu.outerHeight() || 180));
      $menu.css({ left: left, top: top, display: 'block' });
    }

    function renderMenu() {
      ensureMenu();
      if (!items.length) {
        $menu.html('<div class="trix-ac-empty">No matches</div>');
        positionMenu();
        return;
      }

      var html = '';
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        if (!item) continue;
        var active = i === selectedIndex ? ' is-active' : '';
        var body = options.renderItem
          ? options.renderItem(item, window.TrixAutocompletePicker.escapeHtml)
          : window.TrixAutocompletePicker.escapeHtml(item.name);
        html += '<div class="trix-ac-item' + active + '" role="option" data-index="' + i + '">' + body + '</div>';
      }
      $menu.html(html);
      positionMenu();

      var $active = $menu.find('.trix-ac-item.is-active');
      if ($active.length) {
        var menuEl = $menu.get(0);
        var top = $active.position().top;
        var bottom = top + $active.outerHeight();
        if (top < 0) menuEl.scrollTop += top;
        if (bottom > $menu.innerHeight()) menuEl.scrollTop += bottom - $menu.innerHeight();
      }
    }

    function load(query) {
      if (request && request.abort) {
        try { request.abort(); } catch (e) { /* ignore */ }
      }
      ensureMenu();
      $menu.html('<div class="trix-ac-empty">Searching…</div>');
      positionMenu();

      request = $.ajax({
        url: path,
        data: { q: query || '' },
        dataType: 'json',
        type: 'GET'
      }).done(function (result) {
        var list = result && result[options.resultKey] ? result[options.resultKey] : [];
        items = [];
        for (var i = 0; i < list.length; i++) {
          if (list[i] && list[i].gid && list[i].name) items.push(list[i]);
        }
        selectedIndex = 0;
        renderMenu();
      }).fail(function (xhr, status) {
        if (status === 'abort') return;
        items = [];
        ensureMenu();
        $menu.html('<div class="trix-ac-empty">Search failed</div>');
        positionMenu();
      }).always(function () {
        request = null;
      });
    }

    function pick(index) {
      var item = items[index];
      if (!item || triggerIndex == null) return;

      var endPos = editor.getPosition();
      var startPos = triggerIndex;
      if (endPos > startPos) {
        editor.setSelectedRange([startPos, endPos]);
        editor.deleteInDirection('forward');
      }

      var label = String(item.name || '').replace(/\s+/g, ' ').trim();
      var embed = "<span class='mention'>" + options.prefix + window.TrixAutocompletePicker.escapeHtml(label) + '</span>';
      var attachment = new Trix.Attachment({
        content: embed,
        type: options.attachmentType,
        gid: item.gid
      });
      editor.insertAttachment(attachment);
      closeMenu();
    }

    function sync() {
      var pos = editor.getPosition();
      var text = editor.getDocument().toString();
      var match = window.TrixAutocompletePicker.activeTrigger(text, pos, options.trigger);

      if (!match) {
        if (open) closeMenu();
        return;
      }

      triggerIndex = match.triggerIndex;
      open = true;
      ensureMenu();
      positionMenu();

      if (match.query === lastQuery) return;
      lastQuery = match.query;

      if (loadTimer) clearTimeout(loadTimer);
      loadTimer = setTimeout(function () {
        load(match.query);
      }, 120);
    }

    function onKeyDown(event) {
      if (!open) return;

      if (event.key === 'ArrowDown') {
        event.preventDefault();
        event.stopPropagation();
        if (!items.length) return;
        selectedIndex = (selectedIndex + 1) % items.length;
        renderMenu();
      } else if (event.key === 'ArrowUp') {
        event.preventDefault();
        event.stopPropagation();
        if (!items.length) return;
        selectedIndex = (selectedIndex - 1 + items.length) % items.length;
        renderMenu();
      } else if (event.key === 'Enter' || event.key === 'Tab') {
        if (!items.length) return;
        event.preventDefault();
        event.stopPropagation();
        pick(selectedIndex);
      } else if (event.key === 'Escape') {
        event.preventDefault();
        event.stopPropagation();
        closeMenu();
      }
    }

    function onDocMouseDown(event) {
      if (!open || !$menu) return;
      var target = event.target;
      if (trix === target || trix.contains(target)) return;
      if ($menu.is(target) || $menu.has(target).length) return;
      closeMenu();
    }

    trix.addEventListener('trix-change', sync);
    // Capture so we can handle arrows/enter before Trix does.
    trix.addEventListener('keydown', onKeyDown, true);
    document.addEventListener('mousedown', onDocMouseDown);
  }
};
