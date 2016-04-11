var JiangGaoWang = JiangGaoWang || {};

JiangGaoWang.UserPage = {
  // clik login or register button
  clickLoginRegister: function() {
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
    JiangGaoWang.UserPage.clickLoginRegister();
  }
};

$(function() {
  JiangGaoWang.UserPage.init();
});
