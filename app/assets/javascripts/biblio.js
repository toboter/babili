$(document).on("turbolinks:load", function()  {
  var selectizeCallback = null;

  $(".journal-modal").on("hide.bs.modal", function(e) {
    if (selectizeCallback != null) {
      selectizeCallback();
      selecitzeCallback = null;
    }

    $("#new_biblio_journal").trigger("reset");
    $.rails.enableFormElements($("#new_biblio_journal"));
  });

  $("#new_biblio_journal").on("submit", function(e) {
    e.preventDefault();
    $.ajax({
      method: "POST",
      url: $(this).attr("action") + '.json',
      data: $(this).serialize(),
      success: function(response) {
        selectizeCallback({value: response.id, text: response.name_abbr});
        selectizeCallback = null;

        $(".journal-modal").modal('toggle');
      }
    });
  });

  $(".journal-selectize").selectize({
    create: function(input, callback) {
      selectizeCallback = callback;

      $(".journal-modal").modal();
      $("#biblio_journal_name").val(input);
    }
  });


  $(".serie-modal").on("hide.bs.modal", function(e) {
    if (selectizeCallback != null) {
      selectizeCallback();
      selecitzeCallback = null;
    }

    $("#new_biblio_serie").trigger("reset");
    $.rails.enableFormElements($("#new_biblio_serie"));
  });

  $("#new_biblio_serie").on("submit", function(e) {
    e.preventDefault();
    $.ajax({
      method: "POST",
      url: $(this).attr("action") + '.json',
      data: $(this).serialize(),
      success: function(response) {
        selectizeCallback({value: response.id, text: response.title});
        selectizeCallback = null;

        $(".serie-modal").modal('toggle');
      }
    });
  });

  $(".serie-selectize").selectize({
    create: function(input, callback) {
      selectizeCallback = callback;

      $(".serie-modal").modal();
      $("#biblio_serie_title").val(input);
    }
  });

  $('.repo-selectize').selectize({
    placeholder: 'Add to repository...'
  });


  $('.biblio-entry-selectize').selectize({
    placeholder: 'Add reference...',
    valueField: 'id',
    labelField: 'citation',
    searchField: 'citation',
    load: function(query, callback) {
      if (!query.length) return callback();
      $.ajax({
        url: "/bibliography/entries.json",
        data: { q: query },
        dataType: "json",
        type: 'GET',
        error: function(res){
          callback();
        },
        success: function(res) {
          callback(res.slice(0,10));
        }
      })
    },
    render: {
      option: function(item, escape) {
        return '<div>' + '<strong>' + escape(item.citation) + '</strong>' +
                  '<p class="text-small">' + item.cite + '</p>' +
               '</div>'
      }
    }
  });


  

});