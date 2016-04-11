var Jianggaowang = Jianggaowang || {};

Jianggaowang.UserPage = {
  // clik login or register button
  toggleLoginRegister: function() {
    var $a=$('.user-toggle li a');
    $a.on('click', function() {
      var $this = $(this);
      var currentName=$this.text();
      var $activeLi=$('.user-toggle li.active');
      var $userInfo =$('.user-info');
      $activeLi.removeClass('active');
      $this.parent().addClass('active');
      if(currentName==='注册') {
        $userInfo.removeClass('user-login');
        $userInfo.addClass('user-register');
      }
      else {
        $userInfo.removeClass('user-register');
        $userInfo.addClass('user-login');
      }
    });
  },
  init: function() {
    this.toggleLoginRegister();
  }
};

$(function() {
  Jianggaowang.UserPage.init();
});
