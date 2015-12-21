$(document).ready(function(){

  $('#create_or_edit_event_form #event-content').each(function(i, elem) {
    $(elem).wysihtml5();
  });

});
