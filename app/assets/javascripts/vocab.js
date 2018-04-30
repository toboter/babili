$(document).on('turbolinks:load', function(){
  $('#vocab_tag_list').selectize({
    valueField: 'name',
    labelField: 'name',
    searchField: ['name'],
    placeholder: 'Search vocabularies for topics...',
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
        return '<div>' + '<strong>' + escape(item.name) + '</strong>' +
                  '<p class="text-small">' + '<em>' + escape(item.parents) + '</em>' + '</p>' +
                  '<p class="text-small">' + escape(item.note) + '</p>' +
               '</div>'
      }
    }
  });
  
  $('#vocab_broader_id').selectize({
    delimiter: ',',
    persist: true
  });

  $('#vocab_narrower_id').selectize({
    delimiter: ',',
    persist: true
  });
  
  $('#matches').on('cocoon:after-insert', function(e, addedItem){
    $(addedItem).find('#concept_matches_associatable').selectize({
      valueField: 'id',
      labelField: 'name',
      searchField: 'name',
      placeholder: 'Type to search AAT & local concepts...',
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
          return '<div>' + '<strong>' + escape(item.name) + '</strong>' +
                    '<p class="text-small">' + '<em>' + escape(item.parents) + '</em>' + '</p>' +
                    '<p class="text-small">' + escape(item.note) + '</p>' +
                 '</div>'
        }
      }
    });
  });

});