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
      if (xhr.status !== 201) {
        console.error('Trix upload failed', xhr.status, xhr.responseText);
        return;
      }
      var response = JSON.parse(xhr.responseText);
      // create.json.jbuilder nests under `file`; accept top-level too.
      var file = response.file || response;
      attachment.setAttributes({
        url: file.file_url,
        gid: file.gid,
        type: 'File',
        href: file.html_url
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
