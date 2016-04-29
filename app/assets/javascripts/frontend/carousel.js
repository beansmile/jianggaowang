Jianggaowang.Carousel = {
  setCarousel: function() {
    $('#carousel').slick({
      arrows: false,
      centerMode: true,
      speed: 500,
      autoplay: true,
      autoplaySpeed: 3000,
      variableWidth: true,
      respondTo: 'min',
      focusOnSelect: true,
      slidesToShow: 1,
      slidesToScroll: 1,
      responsive: [
        {
          breakpoint: 1140,
          settings: {
            variableWidth: false,
            arrows: false,
            centerMode: true,
            centerPadding: '0',
            slidesToShow: 1
          }
        }
      ]
    });
  },
  init: function() {
    this.setCarousel();
  }
};

$(function() {
  Jianggaowang.Carousel.init();
});
