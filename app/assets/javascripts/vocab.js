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
      valueField: 'id',
      labelField: 'name',
      searchField: 'name',
      create: true,
      load: function(query, callback) {
        console.log(query);
        if (!query.length) return callback();
        $.ajax({
          url: "/vocabularies/search/terms.json",
          data: { q: query},
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
          return `<div>` + escape(item.name) + `</div>`
        }
      }
    });
  });

});