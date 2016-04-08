(function(){
  var clickLoginRegister = function() {
    var $loginRegister = $(".login-register");
    var $title = $loginRegister.find(".title");
    var $li = $title.find("li");
    $li.on("click", function(e) {
      e.preventDefault();
      e.stopPropagation();
      var currentName= $(this).attr("class");
      $title.find(".active").removeClass("active");
      $(this).addClass("active");
      $loginRegister.find("form.active").removeClass('active');
      $loginRegister.find("."+currentName).addClass("active");
    });
  };

  $(document).ready(function() {
    clickLoginRegister();
  });

})();
