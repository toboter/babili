  //= require froala-editor/js/plugins/colors.min.js
  //= require froala-editor/js/third_party/embedly.min.js
  //= require froala-editor/js/plugins/entities.min.js
  //= require froala-editor/js/plugins/font_size.min.js
  //= require froala-editor/js/plugins/link.min.js
  //= require froala-editor/js/plugins/line_breaker.min.js
  //= require froala-editor/js/plugins/draggable.min.js
  //= require froala-editor/js/plugins/quote.min.js
  //= require froala-editor/js/plugins/image.min.js
  //= require froala-editor/js/plugins/table.min.js
  //= require froala-editor/js/plugins/url.min.js
  //= require froala-editor/js/plugins/special_characters.min.js
  //= require froala-editor/js/plugins/word_paste.min.js

  $(document).on("turbolinks:load", function()  {
    if ( $( ".froala-edit" ).length ) {
      $('.froala-edit').froalaEditor({
        heightMin: 400,
        imageUploadParam: 'upload[file]',
        imageUploadURL: '/raw/files.json',
        requestHeaders: {
          'X-CSRF-Token': Rails.csrfToken()
        }
      })
      .on('froalaEditor.image.uploaded', function (e, editor, response) {
        // Parse response to get image url.
        var img_url = JSON.parse(response)['file_url'];
      
        // Insert image.
        editor.image.insert(img_url, false, null, editor.image.get(), response);

        return false;
      })
      .on('froalaEditor.image.inserted', function (e, editor, $img, response) {
        resp = JSON.parse(response)
        attachment = {};
        attachment['gid'] = resp['gid']
        attachment['type'] = 'File'
        attachment['href'] = resp['html_url']
        $img.attr('data-attachment', JSON.stringify(attachment));
      });
      // $('.fr-wrapper div:first-child').hide();
    }
  });