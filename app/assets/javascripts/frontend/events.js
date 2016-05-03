Jianggaowang.EventsPage = {
  uploadEventsCover: function() {
    var $input = $('#events_cover'),
        $cover = $('.cover');
    Jianggaowang.Common.uploadImage($input, $cover);
  },
  initDatePicker: function() {
    $('#start_time').datetimepicker();
    $('#end_time').datetimepicker();
  },
  init: function() {
    this.uploadEventsCover();
    this.initDatePicker();
  }
};

$(function() {
  Jianggaowang.EventsPage.init();
});
