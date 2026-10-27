/*global $, BabiliSelectize*/

window.ZensusSelectizeCallback = null;

function initZensusSelectize($root) {
  var $scope = $root && $root.length ? $root : $(document);

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".zensus_activity_event"), {
    sortField: "text",
    placeholder: "Select or add event…",
    create: function (input, callback) {
      window.ZensusSelectizeCallback = callback;
      $(".event-modal").modal();
      $("#zensus_event_type").val(input);
    }
  });

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".zensus_appellation"), {
    sortField: "text",
    placeholder: "Select or add appellation…",
    create: function (input, callback) {
      window.ZensusSelectizeCallback = callback;
      $(".name-modal").modal();
      $("#zensus_name").val(input);
    }
  });

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".zensus_appellations_selectize"), {
    placeholder: "Select or add name…",
    create: function (input, callback) {
      window.ZensusSelectizeCallback = callback;
      $(".name-modal").modal();
      $("#zensus_name_name").val(input);
    }
  });

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".zensus_activity_actable"), {
    sortField: "text",
    placeholder: "Select actor…"
  });

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".zensus_activity_property"), {
    sortField: "text",
    placeholder: "Select property…"
  });
}

$(document).on("hide.bs.modal", ".event-modal", function () {
  if (window.ZensusSelectizeCallback != null) {
    window.ZensusSelectizeCallback();
    window.ZensusSelectizeCallback = null;
  }
  $("#new_zensus_event").trigger("reset");
  $.rails.enableFormElements($("#new_zensus_event"));
});

$(document).on("hide.bs.modal", ".name-modal", function () {
  if (window.ZensusSelectizeCallback != null) {
    window.ZensusSelectizeCallback();
    window.ZensusSelectizeCallback = null;
  }
  $("#new_zensus_name").trigger("reset");
  $.rails.enableFormElements($("#new_zensus_name"));
});

$(document).on("submit", "#new_zensus_event", function (e) {
  if (!$(this).closest(".modal").length) return;
  e.preventDefault();
  $.ajax({
    method: "POST",
    url: $(this).attr("action") + ".json",
    data: $(this).serialize(),
    success: function (response) {
      if (window.ZensusSelectizeCallback) {
        window.ZensusSelectizeCallback({ value: response.id, text: response.title });
        window.ZensusSelectizeCallback = null;
      }
      $(".event-modal").modal("toggle");
    }
  });
});

$(document).on("submit", "#new_zensus_name", function (e) {
  if (!$(this).closest(".modal").length) return;
  e.preventDefault();
  $.ajax({
    method: "POST",
    url: $(this).attr("action") + ".json",
    data: $(this).serialize(),
    success: function (response) {
      if (window.ZensusSelectizeCallback) {
        window.ZensusSelectizeCallback({ value: response.id, text: response.name });
        window.ZensusSelectizeCallback = null;
      }
      $(".name-modal").modal("toggle");
    }
  });
});
