Jianggaowang.formVerify = {
  verify: function() {
    var $name = $('#user_name');
    var $email = $('#user_email');
    var $password = $('#user_password');
    var $pwd_confirm = $('#user_password_confirmation');
    var $bio = $('#user_bio');
    var $form = $('#new_user');

    function validateEmail(email) {
      var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      return re.test(email);
    }

    function setTips(ele, value) {
      if (ele.next('.tips').length > 0) {
        ele.next('.tips').html(value);
      } else {
        ele.after('<span class="tips">' + value + '</span>');
      }
    }

    // verify the user name
    $name.on('change blur', function() {
      if ($(this).val() == '') {
        setTips($(this), '用户名为必填');
      } else {
        $(this).next('.tips').remove();
      }
    });

    // verify the user email
    $email.on('change blur', function() {
      if (validateEmail($(this).val())) {
        $(this).next('.tips').remove();
      } else {
        setTips($(this), '电子邮箱格式错误');
      }
    });

    // verify the user password
    $password.on('change blur', function() {
      if ($(this).val().length < 8) {
        setTips($(this), '密码过短（最短为8个字符）');
      } else {
        $(this).next('.tips').remove();
      }
    });

    // verify the user password confirmation
    $pwd_confirm.on('change blur', function() {
      if ($(this).val() === $password.val()) {
        $(this).next('.tips').remove();
      } else {
        setTips($(this), '确认密码不匹配');
      }
    });

    // verify the user name
    $bio.on('change blur', function() {
      if ($(this).val() == '') {
        setTips($(this), '此项为必填');
      } else {
        $(this).next('.tips').remove();
      }
    });

    $form.on('submit', function() {
      if ($(this).find('.tips').length > 0) {
        return false;
      }
    })
  },
  init: function() {
    this.verify();
  }
};

$(function() {
  Jianggaowang.formVerify.init();
});
