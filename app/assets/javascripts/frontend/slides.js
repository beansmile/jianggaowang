Jianggaowang.SlidesPage = {

  uploadSlideAudio: function() {
    function progress() {
      var $progress =  $('#slides_new .progress'),
          $uploadDone = $('#slides_new .upload-done'),
          current = 0;

      $uploadDone.hide();
      $progress.fadeIn();
      var intervalId = setInterval(function() {
        current++;
        $progress.text(current+'%');
        if(current == 100) {
          clearInterval(intervalId);
          $progress.fadeOut(100);
          setTimeout(function() {
            $uploadDone.fadeIn();
          },110);
        }
      },100);
    };

    $('#upload_lecture').change(function() {
      progress();
    });
    $('#upload_audio').change(function() {
      progress();
    });
  },

  init: function() {
    this.uploadSlideAudio();
  }
};

$(function() {
  Jianggaowang.SlidesPage.init();
});
