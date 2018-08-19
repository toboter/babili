# https://anotherengineeringblog.com/twitter-mention-feature-for-rails
# https://github.com/ichord/At.js/wiki
# https://gist.github.com/lawso017/44df47968be36222b874b8c4d94b779b
# https://github.com/ichord/At.js/issues/470

$ ->
  document.addEventListener 'trix-initialize', (event) ->
    element = $('trix-editor')
    element.on 'inserted.atwho', (event, flag, query) ->
      console.log flag
      element[0].editor.insertHTML flag[0].innerHTML
    return


  $('#trix_comment_body')
    .atwho(
      at: '@'
      data: 'http://dev.local:3000/research/people.json'
      displayTpl: "<li>${name}</li>"
      insertTpl: "${atwho-at}${name}"
      limit: 7)
  return