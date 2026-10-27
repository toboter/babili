/*global $, BabiliSelectize*/

function initRepositoriesSelectize($root) {
  var $scope = $root && $root.length ? $root : $(document);

  BabiliSelectize.init(BabiliSelectize.visibleIn($scope, ".repositories_selectize"), {
    placeholder: "Add to repository…"
  });
}
