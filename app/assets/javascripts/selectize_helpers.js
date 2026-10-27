/*global $*/
// Shared Selectize init helpers for @selectize/selectize 0.15 + Cocoon / Bootstrap modals.
window.BabiliSelectize = {
  uninitialized: function ($els) {
    return $($els).filter(function () {
      return !this.selectize;
    });
  },

  revealInput: function (instance) {
    if (!instance || !instance.$control_input) return;
    instance.showInput();
    instance.$control_input.css({
      opacity: 1,
      position: "relative",
      left: 0,
      maxWidth: "none"
    });
    instance.$control_input.data("grow", true);
    instance.$control_input.trigger("update");
    if (instance.updatePlaceholder) instance.updatePlaceholder();
  },

  // Remote results are already filtered server-side — don't drop them client-side.
  keepRemoteScore: function () {
    return function () {
      return 1;
    };
  },

  asList: function (res, key) {
    if (Array.isArray(res)) return res;
    if (res && key && Array.isArray(res[key])) return res[key];
    return [];
  },

  defaults: function (extra) {
    var self = this;
    extra = extra || {};
    var builtIns = {
      dropdownParent: "body",
      allowEmptyOption: true,
      hideSelected: false,
      onInitialize: function () {
        self.revealInput(this);
      },
      onFocus: function () {
        self.revealInput(this);
      },
      onType: function () {
        self.revealInput(this);
      },
      onDropdownOpen: function ($dropdown) {
        $dropdown.css("z-index", 2000);
      }
    };

    var options = $.extend({}, builtIns, extra);

    ["onInitialize", "onFocus", "onType"].forEach(function (hook) {
      if (typeof extra[hook] === "function") {
        var user = extra[hook];
        var builtin = builtIns[hook];
        options[hook] = function () {
          builtin.call(this);
          user.call(this);
        };
      }
    });

    if (typeof extra.onDropdownOpen === "function") {
      var userOpen = extra.onDropdownOpen;
      var builtinOpen = builtIns.onDropdownOpen;
      options.onDropdownOpen = function ($dropdown) {
        builtinOpen.call(this, $dropdown);
        userOpen.call(this, $dropdown);
      };
    }

    return options;
  },

  init: function ($els, options) {
    return this.uninitialized($els).selectize(this.defaults(options));
  },

  initWhenVisible: function ($els, options) {
    var $targets = $($els);
    $targets.each(function () {
      if (this.selectize) {
        BabiliSelectize.revealInput(this.selectize);
      }
    });
    return this.init($targets, options);
  },

  inHiddenModal: function ($el) {
    var $modal = $($el).closest(".modal");
    return $modal.length > 0 && !$modal.hasClass("in") && !$modal.hasClass("show");
  },

  visibleIn: function ($scope, selector) {
    return $scope.find(selector).filter(function () {
      return !BabiliSelectize.inHiddenModal(this);
    });
  },

  // Re-run all known Selectize setups inside a container (modals, cocoon rows, page).
  boot: function ($root) {
    var $scope = $root && $root.length ? $root : $(document);

    if (typeof initVocabSelectize === "function") initVocabSelectize($scope);
    if (typeof initZensusSelectize === "function") initZensusSelectize($scope);
    if (typeof initLocateSelectize === "function") initLocateSelectize($scope);
    if (typeof initBiblioSelectize === "function") initBiblioSelectize($scope);
    if (typeof initRepositoriesSelectize === "function") initRepositoriesSelectize($scope);
  }
};

if (!window.BabiliSelectizeBootstrapped) {
  window.BabiliSelectizeBootstrapped = true;

  $(document).on("turbolinks:load", function () {
    BabiliSelectize.boot($(document));
  });

  $(document).on("cocoon:after-insert", function (_e, insertedItem) {
    BabiliSelectize.boot($(insertedItem));
  });

  $(document).on("shown.bs.modal", ".modal", function () {
    BabiliSelectize.boot($(this));
  });
}
