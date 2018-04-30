$(document).on("turbolinks:load", function()  {
  var selectizeCallback = null;

  $(".place-modal").on("hide.bs.modal", function(e) {
    if (selectizeCallback != null) {
      selectizeCallback();
      selecitzeCallback = null;
    }

    $("#new_locate_place").trigger("reset");
    $.rails.enableFormElements($("#new_locate_place"));
  });

  $("#new_locate_place").on("submit", function(e) {
    e.preventDefault();
    $.ajax({
      method: "POST",
      url: $(this).attr("action") + '.json',
      data: $(this).serialize(),
      success: function(response) {
        console.log(response);
        selectizeCallback({value: response.id, text: response.descriptor});
        selectizeCallback = null;

        $(".place-modal").modal('toggle');
      }
    });
  });

  $(".locate_places_selectize").selectize({
    create: function(input, callback) {
      selectizeCallback = callback;

      $(".place-modal").modal();
      $("#locate_place_toponym").val(input);
    }
  });
});