//= require plugins/colors.min.js
//= require third_party/embedly.min.js
//= require plugins/entities.min.js
//= require plugins/font_size.min.js
//= require plugins/link.min.js
//= require plugins/line_breaker.min.js
//= require plugins/draggable.min.js
//= require plugins/quote.min.js
//= require plugins/image.min.js
//= require plugins/table.min.js
//= require plugins/url.min.js
//= require plugins/special_characters.min.js
//= require plugins/word_paste.min.js

$(document).on("turbolinks:load", function()  {
  $('.froala-edit').froalaEditor({
    heightMin: 400,
    imageUploadParam: 'upload[file]',
    imageUploadURL: '/raw/files.json',
    requestHeaders: {
      'X-CSRF-Token': $.rails.csrfToken()
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

});