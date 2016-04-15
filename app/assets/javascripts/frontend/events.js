Jianggaowang.EventsPage = {
  uploadEventsCover: function() {
    $('#events-cover').change(function(e) {
      var len = e.originalEvent.srcElement.files.length;
      for (var i = 0; i < len; i++) {
        var file = e.originalEvent.srcElement.files[i];
        var img = document.createElement("img");
        var reader = new FileReader();
        reader.onloadend = function() {
          img.src = reader.result;
        }
        reader.readAsDataURL(file);
        $('.cover').prepend(img);
      }
    });
  },
  init: function() {
    this.uploadEventsCover();
  }
};

$(function() {
  Jianggaowang.EventsPage.init();
});
