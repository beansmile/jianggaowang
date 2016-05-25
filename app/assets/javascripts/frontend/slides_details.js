Jianggaowang.SlidesDetailsPage = {

  setSlides: function() {

    var $slider = $('#slider');

    // Set the Slider
    $slider.slick({
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      fade: true,
      speed: 50
    });

    // Prev page btn
    $('.slider-prev').click(function() {
      $slider.slick('slickPrev');
    });

    // Next page btn
    $('.slider-next').click(function() {
      $slider.slick('slickNext');
    });

    // Set current page number
    $slider.on('afterChange', function(event, slick, currentSlide) {
      $('#currentPage').html(currentSlide + 1);
    });

    // Get the images info
    var items = [];
    $('.slides-img img').each(function() {
      var url = $(this).data('original-file-url');
      var width = $(this).attr('data-width');
      var height = $(this).attr('data-height');
      items.push({src: url, w: width, h: height});
    });

    // Fullscreen Btn
    $('#fullscreen').click(function() {
      openPhotoSwipe(items, $slider.slick('slickCurrentSlide'));
      return false;
    });

    var openPhotoSwipe = function(items, currentIndex) {
      var pswpElement = document.querySelectorAll('.pswp')[0];

      // define options (if needed)
      var options = {
        // history & focus options are disabled on CodePen
        history: false,
        focus: false,
        showAnimationDuration: 0,
        hideAnimationDuration: 0
      };

      // Call the PhotoSwipe Plugin
      var gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);
      gallery.init();
      gallery.goTo(currentIndex);
      gallery.listen('close', function() {
        $slider.slick('slickGoTo', this.getCurrentIndex());
      });
    };
  },
  init: function() {
    this.setSlides();
  }
};

$(function() {
  Jianggaowang.SlidesDetailsPage.init();
});
