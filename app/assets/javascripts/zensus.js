$(document).on('turbolinks:load', function(){

  var selectizeCallback = null;
  
  $(".event-modal").on("hide.bs.modal", function(e) {
    if (selectizeCallback != null) {
      selectizeCallback();
      selecitzeCallback = null;
    }

    $("#new_zensus_event").trigger("reset");
    $.rails.enableFormElements($("#new_zensus_event"));
  });
 
  $("#new_zensus_event").on("submit", function(e) {
    e.preventDefault();
    $.ajax({
      method: "POST",
      url: $(this).attr("action") + '.json',
      data: $(this).serialize(),
      success: function(response) {
        selectizeCallback({value: response.id, text: response.description});
        selectizeCallback = null;

        $(".event-modal").modal('toggle');
      }
    });
  });
  
    
  $('#activities').on('cocoon:after-insert', function(e, addedItem){
    $(addedItem).find('.zensus_activity_event').selectize({
      sortField: 'text',
      create: function(input, callback) {
        selectizeCallback = callback;
  
        $(".event-modal").modal();
        $("#zensus_event_type").val(input);
      },
      placeholder: 'Click to select event, type to add...'
    });

    $(addedItem).find('.zensus_activity_actable').selectize({
      sortField: 'text'
    });

    $(addedItem).find('.zensus_activity_property').selectize({
      sortField: 'text',
      placeholder: 'Click to select property...'
    });
  });

  $('.zensus_activity_event').selectize({
    sortField: 'text',
    create: function(input, callback) {
      selectizeCallback = callback;

      $(".event-modal").modal();
      $("#zensus_event_type").val(input);
    },
    placeholder: 'Click to select event, type to add...'
  });

  $('.zensus_activity_actable').selectize({
    sortField: 'text',
    placeholder: 'Click to select actor...'
  });

  $('.zensus_activity_property').selectize({
    sortField: 'text',
    placeholder: 'Click to select property...'
  });

});