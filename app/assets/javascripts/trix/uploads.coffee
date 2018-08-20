# https://gorails.com/episodes/trix-editor
# https://www.driftingruby.com/episodes/wysiwyg-editor-with-trix

$ ->
  document.addEventListener 'trix-attachment-add', (event) ->
    attachment = event.attachment
    if attachment.file
      return sendFile(attachment)
    return

  sendFile = (attachment) ->
    file = attachment.file
    form = new FormData
    form.append 'Content-Type', file.type
    form.append 'upload[file]', file
    xhr = new XMLHttpRequest
    xhr.open 'POST', '/raw/files.json', true
    xhr.setRequestHeader 'X-CSRF-Token', $.rails.csrfToken()

    xhr.upload.onprogress = (event) ->
      progress = undefined
      progress = event.loaded / event.total * 100
      attachment.setUploadProgress progress
      return

    xhr.onload = ->
      if xhr.status == 201
        response = JSON.parse(xhr.responseText)
        return attachment.setAttributes(
          url: response.file_url
          gid: response.gid
          type: 'File'
          href: response.html_url)
      return

    xhr.send form
  return