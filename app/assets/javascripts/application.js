// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require toastr
//= require bootstrap-markdown-bundle
//= require cocoon
//= require selectize
//= require bootstrap
//= require turbolinks
//= require turbolinks-compatibility
//= require_tree .

$(function () {
  $('[data-toggle="tooltip"]').tooltip();
  $('.about-content img, .post-content img').tooltip({
      placement: 'bottom'
  });
  $('[data-toggle="popover"]').popover();
})

// fixing changing width of a panel while affix-scrolling
$(document).on('affixed.bs.affix',function(e){
    $('.affix').each(function(){
        var elem = $(this);
        var parentPanel = $(elem).parent();
        var resizeFn = function () {
            var parentAffixWidth = $(parentPanel).width();
            elem.width(parentAffixWidth);
        };      

        resizeFn();
        //$(window).resize(resizeFn);
    });
});

$(document).ready(function () {
    var maxheight=63;
    var showText = "<i class='fa fa-angle-down fa-2x'></i>";
    var hideText = "<i class='fa fa-angle-up fa-2x'></i>";

    $('#organization-description').each(function () {
      var text = $(this);
      if (text.height() > maxheight){
          text.css({ 'overflow': 'hidden','height': maxheight + 'px' });

          var link = $('<a href="#">' + showText + '</a>');
          var linkDiv = $('<div class="text-center"></div>');
          linkDiv.append(link);
          $(this).after(linkDiv);

          link.click(function (event) {
            event.preventDefault();
            if (text.height() > maxheight) {
                $(this).html(showText);
                text.css('height', maxheight + 'px');
            } else {
                $(this).html(hideText);
                text.css('height', 'auto');
            }
          });
      }       
    });
 });