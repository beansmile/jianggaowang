/* for the common function */
Jianggaowang.Common = {
  uploadImage: function(input, cover) {
    input.change(function(e) {
      cover.find('img').remove();
      var len = e.originalEvent.srcElement.files.length;
      for (var i = 0; i < len; i++) {
        var file = e.originalEvent.srcElement.files[i];
        var img = document.createElement('img');
        var reader = new FileReader();
        reader.onloadend = function() {
          img.src = reader.result;
        };
        reader.readAsDataURL(file);
        cover.prepend(img);
      }
    });
  }
};
