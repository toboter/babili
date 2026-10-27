/*global $, BabiliSelectize*/

window.LocateSelectizeCallback = null;

function initLocateSelectize($root) {
  var $scope = $root && $root.length ? $root : $(document);

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".locate_places_selectize"), {
    placeholder: "Select or add place…",
    create: function (input, callback) {
      window.LocateSelectizeCallback = callback;
      $(".place-modal").modal();
      $("#locate_place_toponym").val(input);
    }
  });
}

$(document).on("hide.bs.modal", ".place-modal", function () {
  if (window.LocateSelectizeCallback != null) {
    window.LocateSelectizeCallback();
    window.LocateSelectizeCallback = null;
  }
  $("#new_locate_place").trigger("reset");
  $.rails.enableFormElements($("#new_locate_place"));
});

$(document).on("submit", "#new_locate_place", function (e) {
  if (!$(this).closest(".modal").length) return;
  e.preventDefault();
  $.ajax({
    method: "POST",
    url: $(this).attr("action") + ".json",
    data: $(this).serialize(),
    success: function (response) {
      if (window.LocateSelectizeCallback) {
        window.LocateSelectizeCallback({
          value: response.id,
          text: response.descriptor
        });
        window.LocateSelectizeCallback = null;
      }
      $(".place-modal").modal("toggle");
    }
  });
});
