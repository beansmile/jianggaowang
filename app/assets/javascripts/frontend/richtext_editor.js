var setUpRichTextEditor = function() {
  $('#create_or_edit_event_form #event-content').each(function(i, elem) {
    $(elem).wysihtml5({'toolbar': {'blockquote': false, 'html': true}});
  });
};

// https://github.com/Nerian/bootstrap-wysihtml5-rails#if-using-turbolinks
$(document).on('page:load', function(){
  window['rangy'].initialized = false;
  setUpRichTextEditor(); // hotfix here. because `window['rangy'].initialized = false;` seems doesn't work.
});

$(setUpRichTextEditor);
