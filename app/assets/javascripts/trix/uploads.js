// https://gorails.com/episodes/trix-editor
// https://www.driftingruby.com/episodes/wysiwyg-editor-with-trix
(function () {
  function sendFile(attachment) {
    var file = attachment.file;
    var form = new FormData();
    form.append('Content-Type', file.type);
    form.append('upload[file]', file);

    var xhr = new XMLHttpRequest();
    xhr.open('POST', '/raw/files.json', true);
    xhr.setRequestHeader('X-CSRF-Token', Rails.csrfToken());

    xhr.upload.onprogress = function (event) {
      var progress = (event.loaded / event.total) * 100;
      attachment.setUploadProgress(progress);
    };

    xhr.onload = function () {
      if (xhr.status !== 201) return;
      var response = JSON.parse(xhr.responseText);
      attachment.setAttributes({
        url: response.file_url,
        gid: response.gid,
        type: 'File',
        href: response.html_url
      });
    };

    xhr.send(form);
  }

  if (!window.__trixUploadsListenerBound) {
    document.addEventListener('trix-attachment-add', function (event) {
      var attachment = event.attachment;
      if (attachment && attachment.file) sendFile(attachment);
    });
    window.__trixUploadsListenerBound = true;
  }
})();
