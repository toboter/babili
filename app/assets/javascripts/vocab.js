$(document).on('turbolinks:load', function(){
  
  $('#vocab_broader_id').selectize({
    delimiter: ',',
    persist: true,
    maxItems: 3
  });

  $('#vocab_narrower_id').selectize({
    delimiter: ',',
    persist: true,
    maxItems: 3
  });
  
  $('#matches').on('cocoon:after-insert', function(e, addedItem){
    $(addedItem).find('#vocab_match_string').selectize({
      create: true,
      sortField: 'text'
    });
  });

});