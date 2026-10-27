/*global $, BabiliSelectize*/

function vocabConceptOption(item, escape) {
  var parents = item.parents
    ? '<span class="option-meta text-muted text-small">' + escape(item.parents) + "</span>"
    : "";
  var note = item.note
    ? '<span class="option-meta text-muted text-small">' + escape(item.note) + "</span>"
    : "";
  return (
    '<div class="option-label"><span class="option-title">' +
    escape(item.name || "") +
    "</span>" +
    parents +
    note +
    "</div>"
  );
}

function vocabRemoteLoad(query, callback) {
  if (!query.length) return callback();
  $.ajax({
    url: "/vocabularies/search/terms.json",
    data: { q: query },
    dataType: "json",
    type: "GET",
    timeout: 8000,
    error: function () {
      callback();
    },
    success: function (res) {
      callback(BabiliSelectize.asList(res).slice(0, 10));
    }
  });
}

function initVocabSelectize($root) {
  var $scope = $root && $root.length ? $root : $(document);

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, "#vocab_tag_list"), {
    valueField: "name",
    labelField: "name",
    searchField: ["name"],
    placeholder: "Search topics…",
    delimiter: ",",
    persist: true,
    create: true,
    maxItems: null,
    loadThrottle: 300,
    score: BabiliSelectize.keepRemoteScore,
    load: vocabRemoteLoad,
    render: { option: vocabConceptOption }
  });

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, "#vocab_broader_id"), {
    delimiter: ",",
    persist: true
  });

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, "#vocab_narrower_id"), {
    delimiter: ",",
    persist: true
  });

  BabiliSelectize.init(
    BabiliSelectize.visibleIn($scope, "#concept_matches_associatable, .concept_matches_associatable"),
    {
      valueField: "id",
      labelField: "name",
      searchField: "name",
      placeholder: "Search AAT & concepts…",
      create: true,
      loadThrottle: 300,
      score: BabiliSelectize.keepRemoteScore,
      load: vocabRemoteLoad,
      render: { option: vocabConceptOption }
    }
  );
}
