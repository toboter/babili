    $(document).ready(function () {
      var maxheight=63;
      var showText = "<i class='fa fa-angle-down fa-2x'></i>";
      var hideText = "<i class='fa fa-angle-up fa-2x'></i>";

      $('#project-description').each(function () {
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