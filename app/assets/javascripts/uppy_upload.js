$(document).on('turbolinks:load', function(){
  if ( $( "#dashboard-container" ).length ) {
  var uppy = Uppy.Core({ 
    autoProceed: false,
    debug: true,
    restrictions: {
      maxFileSize: null,
      maxNumberOfFiles: null,
      minNumberOfFiles: null,
      allowedFileTypes: $('#dashboard-container').data('file-types')
    }
  })
  uppy.use(Uppy.Dashboard, { 
    inline: true,
    trigger: '#openDashboardModal',
    height: 300,
    target: '#dashboard-container' 
  })
  uppy.use(Uppy.XHRUpload, {
    endpoint: '/raw/files.json',
    formData: true,
    fieldName: 'upload[file]',
    headers: {
      'X-CSRF-Token': Rails.csrfToken()
    }
  })
  uppy.use(Uppy.Form, {
    target: 'form.with_referenceables',
    getMetaFromForm: false,
    addResultToForm: true,
    resultName: 'referenceables',
    submitOnSuccess: false
  })
  // uppy.on('upload-success', (file, body) => {
  //   referenceable = {
  //     referenceable_gid: body.gid,
  //     referencor_id: $('#dashboard-container').data('updater-id')
  //   };
  //   $('<input />').attr('type', 'hidden')
  //     .attr('name', 'file_uploads[]')
  //     .attr('value', JSON.stringify(referenceable))
  //     .appendTo('form.with_referenceables');
  //   // $('#').push(JSON.stringify(referenceable));
  //   console.log(referenceable);
  // });
  }
});