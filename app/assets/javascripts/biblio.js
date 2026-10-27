/*global $, BabiliSelectize*/

window.BiblioSelectizeCallback = null;

function biblioCreateSelectize($els, modalSelector, inputSelector) {
  BabiliSelectize.init($els, {
    placeholder: "Select or create…",
    create: function (input, callback) {
      window.BiblioSelectizeCallback = callback;
      $(modalSelector).modal();
      $(inputSelector).val(input);
    }
  });
}

function initBiblioSelectize($root) {
  var $scope = $root && $root.length ? $root : $(document);
  var visible = function (sel) {
    return BabiliSelectize.visibleIn($scope, sel);
  };

  biblioCreateSelectize(
    visible(".biblio_journal_selectize"),
    ".journal-modal",
    "#biblio_journal_name"
  );
  biblioCreateSelectize(
    visible(".biblio_series_selectize"),
    ".serie-modal",
    "#biblio_serie_title"
  );
  biblioCreateSelectize(
    visible(".biblio_book_selectize"),
    ".book-modal",
    "#biblio_book_title"
  );
  biblioCreateSelectize(
    visible(".biblio_collection_selectize"),
    ".collection-modal",
    "#biblio_collection_title"
  );
  biblioCreateSelectize(
    visible(".biblio_proceeding_selectize"),
    ".proceeding-modal",
    "#biblio_proceeding_title"
  );

  BabiliSelectize.init(visible(".biblio_entries_selectize"), {
    placeholder: "Add reference…",
    valueField: "id",
    labelField: "citation",
    searchField: "citation",
    loadThrottle: 300,
    score: BabiliSelectize.keepRemoteScore,
    load: function (query, callback) {
      if (!query.length) return callback();
      $.ajax({
        url: "/bibliography/entries.json",
        data: { q: query },
        dataType: "json",
        type: "GET",
        error: function () {
          callback();
        },
        success: function (res) {
          callback(BabiliSelectize.asList(res, "entries").slice(0, 10));
        }
      });
    },
    render: {
      option: function (item, escape) {
        var meta = item.cite
          ? '<span class="option-meta text-muted text-small">' + escape(item.cite) + "</span>"
          : "";
        return (
          '<div class="option-label"><span class="option-title">' +
          escape(item.citation || "") +
          "</span>" +
          meta +
          "</div>"
        );
      }
    }
  });
}

function wireBiblioCreateModal(modalSelector, formSelector, textFromResponse) {
  $(document).on("hide.bs.modal", modalSelector, function () {
    if (window.BiblioSelectizeCallback != null) {
      window.BiblioSelectizeCallback();
      window.BiblioSelectizeCallback = null;
    }
    $(formSelector).trigger("reset");
    $.rails.enableFormElements($(formSelector));
  });

  // Only AJAX-intercept when the form lives in the create modal.
  // Full-page #new_biblio_book (etc.) must submit normally so Rails can redirect.
  $(document).on("submit", formSelector, function (e) {
    if (!$(this).closest(".modal").length) return;

    e.preventDefault();
    $.ajax({
      method: "POST",
      url: $(this).attr("action") + ".json",
      data: $(this).serialize(),
      success: function (response) {
        if (window.BiblioSelectizeCallback) {
          window.BiblioSelectizeCallback({
            value: response.id,
            text: textFromResponse(response)
          });
          window.BiblioSelectizeCallback = null;
        }
        $(modalSelector).modal("toggle");
      }
    });
  });
}

wireBiblioCreateModal(".journal-modal", "#new_biblio_journal", function (r) {
  return r.name_abbr;
});
wireBiblioCreateModal(".serie-modal", "#new_biblio_serie", function (r) {
  return r.title;
});
wireBiblioCreateModal(".book-modal", "#new_biblio_book", function (r) {
  return r.citation;
});
wireBiblioCreateModal(".collection-modal", "#new_biblio_collection", function (r) {
  return r.citation;
});
wireBiblioCreateModal(".proceeding-modal", "#new_biblio_proceeding", function (r) {
  return r.citation;
});
