Jianggaowang.ResponsiveHeader = {
  responsiveHeader: function() {
    $('.custom-toggle').click(function() {
      $(this).toggleClass('active');
      $('.header').toggleClass('open');
      return false;
    });
  },
  init: function() {
    this.responsiveHeader();
  }
};

$(function() {
  Jianggaowang.ResponsiveHeader.init();
});
