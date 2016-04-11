var Jianggaowang = Jianggaowang || {};

Jianggaowang.UserPage = {
  // clik login or register button
  toggleLoginRegister: function() {
    var $loginRegister = $('.login-register');
    var $title = $loginRegister.find('.title');
    var $li = $title.find('li');
    $li.on('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      var currentName= $(this).attr('class');
      $title.find('.active').removeClass('active');
      $(this).addClass('active');
      $loginRegister.find('form.active').removeClass('active');
      $loginRegister.find('.'+currentName).addClass('active');
    });
  },
  init: function() {
    this.toggleLoginRegister();
  }
};

$(function() {
  Jianggaowang.UserPage.init();
});
