Jianggaowang.SlidesDetailsPage = {

  setSlides: function() {
    $('#slider_for').slick({
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      fade: true,
      infinite: false
    });
    $('#total_page').html($('#slider_for .slides-page').length);
    $('.slider-prev').click(function() {
      $('#slider_for').slick('slickPrev');
    });
    $('.slider-next').click(function() {
      $('#slider_for').slick('slickNext');
    });
    $('#slider_for').on('afterChange', function(event, slick, currentSlide) {
      $('#currentPage').html(currentSlide + 1);
    });
  },

  init: function() {
    this.setSlides();
  }
};

$(function() {
  Jianggaowang.SlidesDetailsPage.init();
});
